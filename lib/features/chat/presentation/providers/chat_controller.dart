import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/chat_providers.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_provider.dart';

// ✅ Provider للمستخدم الحالي
final currentUserIdProvider = Provider<String?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.currentUser?.id;
});

// ✅ Controller لإدارة الدردشة
final chatControllerProvider = Provider<ChatController>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  return ChatController(ref, repository, currentUserId);
});

class ChatController {
  final Ref _ref;
  final ChatRepository _repository;
  final String? _currentUserId;

  ChatController(this._ref, this._repository, this._currentUserId);

  // ✅ إنشاء أو جلب محادثة
  Future<String?> getOrCreateConversation({required String otherUserId}) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final conversationId = await _repository.getOrCreateConversation(
        _currentUserId!,
        otherUserId,
      );

      // ✅ تحديث الـ Providers
      _ref.read(conversationIdProvider.notifier).state = conversationId;
      _ref.read(receiverIdProvider.notifier).state = otherUserId;

      return conversationId;
    } catch (e) {
      print('❌ Error getting/creating conversation: $e');
      return null;
    }
  }

  // ✅ إرسال رسالة
  Future<void> sendMessage({
    required String conversationId,
    required String receiverId,
    required String message,
  }) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    if (message.trim().isEmpty) return;

    await _repository.sendMessage(
      conversationId: conversationId,
      senderId: _currentUserId!,
      receiverId: receiverId,
      message: message,
    );
  }

  // ✅ تعليم الرسائل كمقروءة
  Future<void> markMessagesAsRead(String conversationId) async {
    if (_currentUserId == null) return;

    await _repository.markConversationAsRead(conversationId, _currentUserId!);
  }

  // ✅ حذف محادثة
  Future<void> deleteConversation(String conversationId) async {
    if (_currentUserId == null) return;

    await _repository.deleteConversation(conversationId, _currentUserId!);
  }

  // ✅ الحصول على عدد الرسائل غير المقروءة
  Future<int> getUnreadCount() async {
    if (_currentUserId == null) return 0;

    return await _repository.getUnreadCount(_currentUserId!);
  }
}
