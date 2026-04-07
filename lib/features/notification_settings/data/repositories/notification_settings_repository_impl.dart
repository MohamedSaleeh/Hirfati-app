import '../../domain/models/notification_settings_model.dart';
import '../../domain/repositories/notification_settings_repository.dart';
import '../datasources/notification_settings_supabase_datasource.dart';

class NotificationSettingsRepositoryImpl implements NotificationSettingsRepository {
  final NotificationSettingsSupabaseDatasource _datasource;

  NotificationSettingsRepositoryImpl(this._datasource);

  @override
  Future<NotificationSettingsModel> getSettings(String userId) async {
    return await _datasource.getSettings(userId);
  }

  @override
  Future<NotificationSettingsModel> updateSettings(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    return await _datasource.updateSettings(userId, updates);
  }

  @override
  Future<void> updatePushEnabled(String userId, bool value) async {
    await _datasource.updatePushEnabled(userId, value);
  }

  @override
  Future<void> updateEmailEnabled(String userId, bool value) async {
    await _datasource.updateEmailEnabled(userId, value);
  }

  @override
  Future<void> updateSmsEnabled(String userId, bool value) async {
    await _datasource.updateSmsEnabled(userId, value);
  }

  @override
  Future<void> updateOrderConfirmation(String userId, bool value) async {
    await _datasource.updateOrderConfirmation(userId, value);
  }

  @override
  Future<void> updateOrderStatus(String userId, bool value) async {
    await _datasource.updateOrderStatus(userId, value);
  }

  @override
  Future<void> updatePromotions(String userId, bool value) async {
    await _datasource.updatePromotions(userId, value);
  }
}