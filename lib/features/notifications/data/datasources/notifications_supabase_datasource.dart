import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/notification_model.dart';

class NotificationsSupabaseDatasource {
  final SupabaseClient _client;

  NotificationsSupabaseDatasource(this._client);

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) {
      // ✅ التأكد من أن type ليس null
      final typeValue = json['type'] as String? ?? 'system';

      return NotificationModel(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        type: _parseNotificationType(typeValue),
        isRead: json['is_read'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
      );
    }).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllAsRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _client.from('notifications').delete().eq('id', notificationId);
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? orderId,
  }) async {
    await _client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type.name,
      'order_id': orderId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'order':
        return NotificationType.order;
      case 'message':
        return NotificationType.message;
      case 'review':
        return NotificationType.review;
      case 'payment':
        return NotificationType.payment;
      case 'promo':
        return NotificationType.promo;
      default:
        return NotificationType.system;
    }
  }
}
