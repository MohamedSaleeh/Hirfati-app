import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/notification_settings_model.dart';

class NotificationSettingsSupabaseDatasource {
  final SupabaseClient _client;

  NotificationSettingsSupabaseDatasource(this._client);

  Future<NotificationSettingsModel> getSettings(String userId) async {
    final response = await _client
        .from('notification_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      final defaultSettings = {
        'user_id': userId,
        'push_enabled': true,
        'email_enabled': true,
        'sms_enabled': false,
        'order_confirmation': true,
        'order_status': true,
        'promotions': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),

      };
      final insertResponse = await _client
          .from('notification_settings')
          .insert(defaultSettings)
          .select()
          .single();
            return NotificationSettingsModel(
        id: insertResponse['id'] as String? ?? '',
        userId: insertResponse['user_id'] as String? ?? userId,
        pushEnabled: insertResponse['push_enabled'] as bool? ?? true,
        emailEnabled: insertResponse['email_enabled'] as bool? ?? true,
        smsEnabled: insertResponse['sms_enabled'] as bool? ?? false,
        orderConfirmation: insertResponse['order_confirmation'] as bool? ?? true,
        orderStatus: insertResponse['order_status'] as bool? ?? true,
        promotions: insertResponse['promotions'] as bool? ?? true,
        createdAt: insertResponse['created_at'] != null 
            ? DateTime.tryParse(insertResponse['created_at'])
            : null,
        updatedAt: insertResponse['updated_at'] != null 
            ? DateTime.tryParse(insertResponse['updated_at'])
            : null,
      );
    }

       return NotificationSettingsModel(
      id: response['id'] as String? ?? '',
      userId: response['user_id'] as String? ?? userId,
      pushEnabled: response['push_enabled'] as bool? ?? true,
      emailEnabled: response['email_enabled'] as bool? ?? true,
      smsEnabled: response['sms_enabled'] as bool? ?? false,
      orderConfirmation: response['order_confirmation'] as bool? ?? true,
      orderStatus: response['order_status'] as bool? ?? true,
      promotions: response['promotions'] as bool? ?? true,
      createdAt: response['created_at'] != null 
          ? DateTime.tryParse(response['created_at'])
          : null,
      updatedAt: response['updated_at'] != null 
          ? DateTime.tryParse(response['updated_at'])
          : null,
    );
  }

  Future<NotificationSettingsModel> updateSettings(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    updates['updated_at'] = DateTime.now().toIso8601String();
    
    final response = await _client
        .from('notification_settings')
        .update(updates)
        .eq('user_id', userId)
        .select()
        .single();

    return NotificationSettingsModel.fromJson(response);
  }

  Future<void> updatePushEnabled(String userId, bool value) async {
    await _client
        .from('notification_settings')
        .update({'push_enabled': value, 'updated_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }

  Future<void> updateEmailEnabled(String userId, bool value) async {
    await _client
        .from('notification_settings')
        .update({'email_enabled': value, 'updated_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }

  Future<void> updateSmsEnabled(String userId, bool value) async {
    await _client
        .from('notification_settings')
        .update({'sms_enabled': value, 'updated_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }

  Future<void> updateOrderConfirmation(String userId, bool value) async {
    await _client
        .from('notification_settings')
        .update({'order_confirmation': value, 'updated_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }

  Future<void> updateOrderStatus(String userId, bool value) async {
    await _client
        .from('notification_settings')
        .update({'order_status': value, 'updated_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }

  Future<void> updatePromotions(String userId, bool value) async {
    await _client
        .from('notification_settings')
        .update({'promotions': value, 'updated_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }
}