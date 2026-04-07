import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/chat_user_model.dart';
import '../../domain/models/conversation_model.dart';
import '../../domain/models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_supabase_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSupabaseDatasource _datasource;

  ChatRepositoryImpl(this._datasource);

  @override
  Future<List<ConversationModel>> getConversations(String userId) async {
    print('🔍 Fetching conversations for user: $userId');
    final result = await _datasource.getConversations(userId);
    print('📊 Found ${result.length} conversations');
    for (var conv in result) {
      print('  - ${conv.otherUserName}: ${conv.lastMessage}');
    }
    return result;
  }

  @override
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _datasource.getMessages(conversationId);
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
    String messageType = 'text',
    List<Map<String, dynamic>> attachments = const [],
  }) async {
    return await _datasource.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      messageType: messageType,
      attachments: attachments,
    );
  }

  @override
  Future<void> markAsRead(String messageId) async {
    await _datasource.markAsRead(messageId);
  }

  @override
  Future<void> markConversationAsRead(
    String conversationId,
    String userId,
  ) async {
    await _datasource.markConversationAsRead(conversationId, userId);
  }

  @override
  Future<String> getOrCreateConversation(String user1Id, String user2Id) async {
    return await _datasource.getOrCreateConversation(user1Id, user2Id);
  }

  @override
  Future<ChatUserModel?> getUser(String userId) async {
    return await _datasource.getUser(userId);
  }

  @override
  Future<String?> uploadAttachment(
    String userId,
    String fileName,
    List<int> bytes,
  ) async {
    return await _datasource.uploadAttachment(userId, fileName, bytes);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    return await _datasource.getUnreadCount(userId);
  }

  @override
  Stream<void> subscribeToNewMessages(String userId) {
    return _datasource.subscribeToNewMessages(userId);
  }

  @override
  Future<void> sendChatNotification({
    required String receiverId,
    required String senderName,
    required String message,
    required String conversationId,
    required String senderId,
  }) async {
    await _datasource.sendChatNotification(
      receiverId: receiverId,
      senderName: senderName,
      message: message,
      conversationId: conversationId,
      senderId: senderId,
    );
  }

  @override
  Future<ChatUserModel?> getCurrentUser() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    return await _datasource.getUser(user.id);
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    print('🗑️ Repository: Deleting message: $messageId');
    await _datasource.deleteMessage(messageId);
  }

  @override
  Future<void> deleteConversation(String conversationId, String userId) async {
    print(
      '🗑️ Repository: Deleting conversation: $conversationId for user: $userId',
    );
    await _datasource.deleteConversation(conversationId, userId);
  }

  @override
  Future<void> deleteMessageNotification(
    String receiverId,
    String message,
  ) async {
    print(
      '🗑️ Repository: Deleting message notification for receiver: $receiverId with message: $message',
    );
    await _datasource.deleteMessageNotification(receiverId, message);
  }
}
