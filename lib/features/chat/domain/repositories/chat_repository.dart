import 'dart:async';
import '../models/message_model.dart';
import '../models/conversation_model.dart';
import '../models/chat_user_model.dart';

abstract class ChatRepository {
  Future<List<ConversationModel>> getConversations(String userId);
  Stream<List<MessageModel>> getMessages(String conversationId);
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
    String messageType = 'text',
    List<Map<String, dynamic>> attachments = const [],
  });
  Future<void> markAsRead(String messageId);
  Future<void> markConversationAsRead(String conversationId, String userId);
  Future<String> getOrCreateConversation(String user1Id, String user2Id);
  Future<ChatUserModel?> getUser(String userId);
  Future<String?> uploadAttachment(
    String userId,
    String fileName,
    List<int> bytes,
  );

  Future<int> getUnreadCount(String userId);
  Stream<void> subscribeToNewMessages(String userId);
  Future<void> sendChatNotification({
    required String receiverId,
    required String senderName,
    required String message,
    required String conversationId,
    required String senderId,
  });
  Future<ChatUserModel?> getCurrentUser();
  Future<void> deleteMessage(String messageId);
  Future<void> deleteConversation(String conversationId, String userId);
  Future<void> deleteMessageNotification(String receiverId, String message);
  
}
