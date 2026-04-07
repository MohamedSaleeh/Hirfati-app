import 'dart:async';
import 'dart:typed_data';

import 'package:hirfati/translations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/chat_user_model.dart';
import '../../domain/models/conversation_model.dart';
import '../../domain/models/message_model.dart';

class ChatSupabaseDatasource {
  final SupabaseClient _client;

  ChatSupabaseDatasource(this._client);

  Future<List<ConversationModel>> getConversations(String userId) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📞 getConversations() called');
    print('   - userId: $userId');

    // جلب المحادثات
    final conversations = await _client
        .from('conversations')
        .select()
        .or('user1_id.eq.$userId,user2_id.eq.$userId')
        .order('last_message_at', ascending: false);

    print('   - Found ${conversations.length} conversations');

    final List<ConversationModel> result = [];

    for (var conv in conversations) {
      final otherUserId = conv['user1_id'] == userId
          ? conv['user2_id']
          : conv['user1_id'];

      print('   - Processing conversation: ${conv['id']}');
      print('     otherUserId: $otherUserId');

      // جلب معلومات المستخدم الآخر
      final userData = await _client
          .from('profiles')
          .select('id, full_name, avatar_url, role')
          .eq('id', otherUserId)
          .single();

      // جلب عدد الرسائل غير المقروءة
      final unreadCount = await _getUnreadCount(conv['id'], userId);

      result.add(
        ConversationModel(
          id: conv['id'],
          otherUserId: otherUserId,
          otherUserName: userData['full_name'],
          otherUserAvatar: userData['avatar_url'],
          lastMessage: conv['last_message'],
          lastMessageTime: conv['last_message_at'] != null
              ? DateTime.parse(conv['last_message_at'])
              : null,
          unreadCount: unreadCount,
        ),
      );

      print('     ✅ Added conversation with: ${userData['full_name']}');
    }

    print('📞 getConversations() returning ${result.length} conversations');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    return result;
  }

  Stream<List<MessageModel>> getMessages(String conversationId) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('💬 getMessages() called');
    print('   - conversationId: $conversationId');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .map((data) {
          final messages = (data as List)
              .map(
                (json) => MessageModel(
                  id: json['id'],
                  conversationId: json['conversation_id'],
                  senderId: json['sender_id'],
                  receiverId: json['receiver_id'],
                  message: json['message'],
                  messageType: _parseMessageType(json['message_type']),
                  attachments: json['attachments'] != null
                      ? List<Map<String, dynamic>>.from(json['attachments'])
                      : [],
                  isRead: json['is_read'] ?? false,
                  createdAt: json['created_at'] != null
                      ? DateTime.parse(json['created_at'])
                      : DateTime.now(),
                ),
              )
              .toList();

          print('💬 Stream emitted ${messages.length} messages');
          return messages;
        });
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
    String messageType = 'text',
    List<Map<String, dynamic>> attachments = const [],
  }) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 sendMessage() called');
    print('   - conversationId: $conversationId');
    print('   - senderId: $senderId');
    print('   - receiverId: $receiverId');
    print('   - message: $message');

    final response = await _client
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': senderId,
          'receiver_id': receiverId,
          'message': message,
          'message_type': messageType,
          'attachments': attachments,
          'created_at': DateTime.now().toIso8601String(),
          'is_read': false,
        })
        .select()
        .single();

    print('   ✅ Message inserted with id: ${response['id']}');

    // تحديث آخر رسالة في المحادثة
    await _client
        .from('conversations')
        .update({
          'last_message': message,
          'last_message_at': DateTime.now().toIso8601String(),
        })
        .eq('id', conversationId);

    print('   ✅ Conversation updated with last message');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return MessageModel(
      id: response['id'],
      conversationId: response['conversation_id'],
      senderId: response['sender_id'],
      receiverId: response['receiver_id'],
      message: response['message'],
      messageType: _parseMessageType(response['message_type']),
      attachments: response['attachments'] != null
          ? List<Map<String, dynamic>>.from(response['attachments'])
          : [],
      isRead: response['is_read'] ?? false,
      createdAt: response['created_at'] != null
          ? DateTime.parse(response['created_at'])
          : DateTime.now(),
    );
  }

  Future<void> markAsRead(String messageId) async {
    print('📖 markAsRead() called - messageId: $messageId');
    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('id', messageId);
  }

  Future<void> markConversationAsRead(
    String conversationId,
    String userId,
  ) async {
    print('📖 markConversationAsRead() called');
    print('   - conversationId: $conversationId');
    print('   - userId: $userId');

    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .eq('receiver_id', userId)
        .neq('is_read', true);

    print('   ✅ All messages marked as read');
  }

  Future<String> getOrCreateConversation(String user1Id, String user2Id) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔍 getOrCreateConversation() called');
    print('   📌 user1Id: $user1Id');
    print('   📌 user2Id: $user2Id');

    // ✅ 1. التحقق من وجود المستخدمين في جدول profiles
    final user1Profile = await _client
        .from('profiles')
        .select('id')
        .eq('id', user1Id)
        .maybeSingle();

    final user2Profile = await _client
        .from('profiles')
        .select('id')
        .eq('id', user2Id)
        .maybeSingle();

    if (user1Profile == null) {
      throw Exception('User $user1Id does not exist in profiles');
    }

    if (user2Profile == null) {
      throw Exception('User $user2Id does not exist in profiles');
    }

    // ✅ 2. البحث عن محادثة موجودة (الطريقة الصحيحة)
    // استخدام and() للبحث عن تطابق تام
    final existing = await _client
        .from('conversations')
        .select('id')
        .or(
          'and(user1_id.eq.$user1Id,user2_id.eq.$user2Id),and(user1_id.eq.$user2Id,user2_id.eq.$user1Id)',
        )
        .maybeSingle();

    if (existing != null) {
      print('✅ Existing conversation found: ${existing['id']}');
      return existing['id'];
    }

    // ✅ 3. إنشاء محادثة جديدة
    print('📝 Creating new conversation...');

    final newConversation = await _client
        .from('conversations')
        .insert({
          'user1_id': user1Id,
          'user2_id': user2Id,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    print('✅ New conversation created: ${newConversation['id']}');
    return newConversation['id'];
  }

  Future<ChatUserModel?> getUser(String userId) async {
    print('🔍 getUser() called - userId: $userId');
    try {
      final response = await _client
          .from('profiles')
          .select('id, full_name, avatar_url, role')
          .eq('id', userId)
          .single();

      print('   ✅ Found user: ${response['full_name']} (${response['role']})');
      return ChatUserModel(
        id: response['id'],
        name: response['full_name'],
        avatarUrl: response['avatar_url'],
        role: response['role'],
      );
    } catch (e) {
      print('   ❌ User not found: $e');
      return null;
    }
  }

  Future<String?> uploadAttachment(
    String userId,
    String fileName,
    List<int> bytes,
  ) async {
    print(
      '📎 uploadAttachment() called - userId: $userId, fileName: $fileName',
    );
    final path =
        'chat_attachments/$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final uint8List = Uint8List.fromList(bytes);
    await _client.storage.from('chat').uploadBinary(path, uint8List);
    final url = _client.storage.from('chat').getPublicUrl(path);
    print('   ✅ Uploaded to: $url');
    return url;
  }

  Future<int> _getUnreadCount(String conversationId, String userId) async {
    final count = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .eq('receiver_id', userId)
        .eq('is_read', false)
        .count();

    return count.count;
  }

  MessageType _parseMessageType(String? type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'location':
        return MessageType.location;
      default:
        return MessageType.text;
    }
  }

  Future<int> getUnreadCount(String userId) async {
    print('🔔 getUnreadCount() called - userId: $userId');
    final count = await _client
        .from('messages')
        .select()
        .eq('receiver_id', userId)
        .eq('is_read', false)
        .count();

    print('   📊 Unread count: ${count.count}');
    return count.count;
  }

  Stream<void> subscribeToNewMessages(String userId) {
    print('🔔 subscribeToNewMessages() called - userId: $userId');
    final controller = StreamController<void>();

    final subscription = _client
        .channel('messages-changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          callback: (payload) async {
            if (payload.newRecord['receiver_id'] == userId &&
                payload.newRecord['is_read'] == false) {
              print('🔔 New message received for user: $userId');
              if (!controller.isClosed) {
                controller.add(null);
              }
            }
          },
        )
        .subscribe();

    controller.onCancel = () {
      _client.removeChannel(subscription);
    };

    return controller.stream;
  }

  Future<void> sendChatNotification({
    required String receiverId,
    required String senderName,
    required String message,
    required String conversationId,
    required String senderId,
  }) async {
    print('📢 sendChatNotification() called');
    print('   - receiverId: $receiverId');
    print('   - senderName: $senderName');
    print('   - message: $message');

    try {
      await _client.functions.invoke(
        'send-notification',
        body: {
          'userId': receiverId,
          'title': 'New message from $senderName'.i18n,
          'body': message,
          'type': 'message',
          'data': {'conversation_id': conversationId, 'sender_id': senderId},
        },
      );
      print('   ✅ Notification sent');
    } catch (e) {
      print('   ❌ Error sending notification: $e');
    }
  }

  Future<ChatUserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    print('👤 getCurrentUser() called');
    if (user == null) {
      print('   ❌ No authenticated user');
      return null;
    }
    print('   ✅ Current user: ${user.id}');
    return await getUser(user.id);
  }

  Future<void> deleteMessage(String messageId) async {
    print('🗑️ deleteMessage() called - messageId: $messageId');
    await _client.from('messages').delete().eq('id', messageId);
    print('   ✅ Message deleted');
  }

  Future<void> deleteConversation(String conversationId, String userId) async {
    print('🗑️ deleteConversation() called');
    print('   - conversationId: $conversationId');
    print('   - userId: $userId');

    await _client
        .from('messages')
        .delete()
        .eq('conversation_id', conversationId);
    print('   ✅ All messages deleted');

    await _client
        .from('conversations')
        .delete()
        .eq('id', conversationId)
        .or('user1_id.eq.$userId,user2_id.eq.$userId');
    print('   ✅ Conversation deleted');
  }

  Future<void> deleteMessageNotification(
    String receiverId,
    String message,
  ) async {
    print('🗑️ deleteMessageNotification() called');
    print('   - receiverId: $receiverId');
    print('   - message: $message');

    try {
      final notification = await _client
          .from('notifications')
          .select()
          .eq('user_id', receiverId)
          .eq('type', 'message')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (notification != null) {
        await _client
            .from('notifications')
            .delete()
            .eq('id', notification['id']);
        print('   ✅ Notification deleted');
      } else {
        print('   ⚠️ No notification found');
      }
    } catch (e) {
      print('   ❌ Error deleting notification: $e');
    }
  }
}
