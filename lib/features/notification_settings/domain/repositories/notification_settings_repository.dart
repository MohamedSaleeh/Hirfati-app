import '../models/notification_settings_model.dart';

abstract class NotificationSettingsRepository {
  Future<NotificationSettingsModel> getSettings(String userId);
  Future<NotificationSettingsModel> updateSettings(
    String userId,
    Map<String, dynamic> updates,
  );
  Future<void> updatePushEnabled(String userId, bool value);
  Future<void> updateEmailEnabled(String userId, bool value);
  Future<void> updateSmsEnabled(String userId, bool value);
  Future<void> updateOrderConfirmation(String userId, bool value);
  Future<void> updateOrderStatus(String userId, bool value);
  Future<void> updatePromotions(String userId, bool value);
}