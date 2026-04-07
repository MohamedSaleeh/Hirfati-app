import '../../domain/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_supabase_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsSupabaseDatasource _datasource;

  NotificationsRepositoryImpl(this._datasource);

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    return await _datasource.getNotifications(userId);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _datasource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _datasource.markAllAsRead(userId);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _datasource.deleteNotification(notificationId);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final notifications = await _datasource.getNotifications(userId);
    return notifications.where((n) => !n.isRead).length;
  }

  @override
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? orderId,
  }) async {
    await _datasource.createNotification(
      userId: userId,
      title: title,
      body: body,
      type: type,
      orderId: orderId,
    );
  }
}