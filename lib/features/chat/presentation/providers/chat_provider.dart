import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/providers/chat_providers.dart';
import '../../domain/models/message_model.dart';
import 'chat_form_provider.dart';

// ============================================================
// Providers
// ============================================================
final conversationIdProvider = StateProvider<String?>((ref) => null);
final receiverIdProvider = StateProvider<String?>((ref) => null);

final currentUserIdProvider = Provider<String?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.currentUser?.id;
});

// ✅ StreamProvider للرسائل مباشرة - يستخدم في الواجهة
final chatMessagesStreamProvider = StreamProvider<List<MessageModel>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final conversationId = ref.watch(conversationIdProvider);

  print('📡 Building chatMessagesStreamProvider');
  print('  - conversationId: $conversationId');

  if (conversationId == null || conversationId.isEmpty) {
    print('⚠️ No conversationId, returning empty stream');
    return Stream.value([]);
  }

  // ✅ إرجاع Stream مباشرة مع التأكد من التحديث
  return repository
      .getMessages(conversationId)
      .handleError((error) {
        print('❌ Error in messages stream: $error');
        return <MessageModel>[];
      })
      .map((messages) {
        print('📨 Stream emitted ${messages.length} messages');
        return messages;
      });
});

// ============================================================
// Providers للإرسال والإجراءات الأخرى
// ============================================================
final isSendingMessageProvider = StateProvider<bool>((ref) => false);

final sendMessageProvider = Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final conversationId = ref.watch(conversationIdProvider);
  final receiverId = ref.watch(receiverIdProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  final isSending = ref.read(isSendingMessageProvider.notifier);
  final resetForm = ref.read(chatFormResetProvider);

  return (String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

    if (conversationId == null || receiverId == null || currentUserId == null) {
      print('❌ Cannot send: missing required data');
      return;
    }

    isSending.state = true;

    try {
      print('📤 Sending message: $trimmedMessage');
      await repository.sendMessage(
        conversationId: conversationId,
        senderId: currentUserId,
        receiverId: receiverId,
        message: trimmedMessage,
      );
      print('✅ Message sent successfully');

      final currentUser = await repository.getCurrentUser();
      final senderName = currentUser?.name ?? 'Unknown';

      await repository.sendChatNotification(
        receiverId: receiverId,
        senderName: senderName,
        message: trimmedMessage,
        conversationId: conversationId,
        senderId: currentUserId,
      );

      await repository.deleteMessageNotification(receiverId, trimmedMessage);
      resetForm();

      // ✅ إعادة تحميل الـ Stream بعد الإرسال
      ref.invalidate(chatMessagesStreamProvider);
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    } finally {
      isSending.state = false;
    }
  };
});

final sendImageProvider = Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final conversationId = ref.watch(conversationIdProvider);
  final receiverId = ref.watch(receiverIdProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  final isSending = ref.read(isSendingMessageProvider.notifier);

  return (String imageUrl) async {
    if (imageUrl.isEmpty) return;

    if (conversationId == null || receiverId == null || currentUserId == null) {
      print('❌ Cannot send image: missing required data');
      return;
    }

    isSending.state = true;

    try {
      await repository.sendMessage(
        conversationId: conversationId,
        senderId: currentUserId,
        receiverId: receiverId,
        message: '',
        messageType: 'image',
        attachments: [
          {'type': 'image', 'url': imageUrl},
        ],
      );
      print('✅ Image sent successfully');

      // ✅ إعادة تحميل الـ Stream بعد الإرسال
      ref.invalidate(chatMessagesStreamProvider);
    } catch (e) {
      print('❌ Error sending image: $e');
      rethrow;
    } finally {
      isSending.state = false;
    }
  };
});

final markAllMessagesAsReadProvider = Provider<Future<void> Function()>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final conversationId = ref.watch(conversationIdProvider);
  final currentUserId = ref.watch(currentUserIdProvider);

  return () async {
    if (conversationId == null || currentUserId == null) return;

    try {
      await repository.markConversationAsRead(conversationId, currentUserId);
      print('✅ Marked all messages as read');
    } catch (e) {
      print('Error marking all as read: $e');
    }
  };
});

final refreshMessagesProvider = Provider<void Function()>((ref) {
  return () {
    print('🔄 Refreshing messages stream');
    ref.invalidate(chatMessagesStreamProvider);
  };
});

final unreadMessagesCountProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);

  if (currentUserId == null) return Stream.value(0);

  final controller = StreamController<int>();

  Future<void> fetchUnreadCount() async {
    try {
      final unreadCount = await repository.getUnreadCount(currentUserId);
      if (!controller.isClosed) {
        controller.add(unreadCount);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  fetchUnreadCount();

  final subscription = repository.subscribeToNewMessages(currentUserId).listen((
    _,
  ) {
    fetchUnreadCount();
  });

  final timer = Timer.periodic(const Duration(seconds: 30), (_) {
    fetchUnreadCount();
  });

  ref.onDispose(() {
    timer.cancel();
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});

// ✅ دالة حذف الرسالة
final deleteMessageProvider = Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(chatRepositoryProvider);

  return (String messageId) async {
    try {
      print('🗑️ Deleting message: $messageId');
      await repository.deleteMessage(messageId);
      print('✅ Message deleted successfully');

      // ✅ تحديث الـ Stream بعد الحذف
      ref.invalidate(chatMessagesStreamProvider);
    } catch (e) {
      print('❌ Error deleting message: $e');
      rethrow;
    }
  };
});

// ✅ دالة حذف محادثة كاملة مع جميع رسائلها
final deleteConversationProvider = Provider<Future<void> Function(String)>((
  ref,
) {
  final repository = ref.watch(chatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);

  return (String conversationId) async {
    if (currentUserId == null) {
      print('❌ Cannot delete: user not logged in');
      return;
    }

    try {
      print('🗑️ Deleting conversation: $conversationId');
      await repository.deleteConversation(conversationId, currentUserId);
      print('✅ Conversation deleted successfully');
    } catch (e) {
      print('❌ Error deleting conversation: $e');
      rethrow;
    }
  };
});
