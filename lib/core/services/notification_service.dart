import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_logger.dart';

Future<bool> _isNotificationTypeEnabled(String type) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) return false;

  try {
    final settings = await supabase
        .from('notification_settings')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (settings == null) return true;

    switch (type) {
      case 'push':
        return settings['push_enabled'] ?? true;
      case 'email':
        return settings['email_enabled'] ?? true;
      case 'sms':
        return settings['sms_enabled'] ?? false;
      case 'order':
        return (settings['order_confirmation'] ?? true) ||
            (settings['order_status'] ?? true);
      case 'promo':
        return settings['promotions'] ?? true;
      default:
        return true;
    }
  } catch (error, stackTrace) {
    AppLogger.error(
      error,
      stackTrace: stackTrace,
      message: 'Unable to check notification settings',
    );
    return true;
  }
}

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // تهيئة الإشعارات المحلية
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // ✅ إنشاء قناة الإشعارات (لـ Android 8+)
    await _createNotificationChannel();

    // طلب الإذن
    await _requestPermissions();

    // الحصول على رمز إشعارات الجهاز
    await _getToken();

    // ربط معالج الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // ربط معالج المقدمة
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // ربط معالج الضغط على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    AppLogger.info('Notification service initialized');
  }

  // ✅ دالة إنشاء قناة الإشعارات (بدون priority و enableVibration)
  static Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'hirfati_channel',
        'Hirfati Notifications',
        description: 'قناة إشعارات تطبيق Hirfati',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      AppLogger.info('Notification channel created');
    }
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    AppLogger.info(
      'Notification permission status: ${settings.authorizationStatus}',
    );
  }

  static Future<void> _getToken() async {
    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      await _saveTokenToSupabase(token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      AppLogger.info('FCM token refreshed');
      await _saveTokenToSupabase(newToken);
    });
  }

  static Future<void> _saveTokenToSupabase(String token) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    try {
      await supabase.from('device_tokens').insert({
        'user_id': user.id,
        'fcm_token': token,
        'updated_at': DateTime.now().toIso8601String(),
      });
      AppLogger.info('FCM token saved');
    } catch (error) {
      AppLogger.warning('FCM token insert failed; attempting ownership update');

      if (error.toString().contains('23505')) {
        try {
          await supabase
              .from('device_tokens')
              .update({
                'user_id': user.id,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('fcm_token', token);
          AppLogger.info('FCM token ownership updated');
        } catch (updateError, stackTrace) {
          AppLogger.error(
            updateError,
            stackTrace: stackTrace,
            message: 'Unable to update FCM token ownership',
          );
        }
      }
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) async {
    AppLogger.info('Foreground notification received');

    final notificationType = message.data['type'] ?? 'push';
    final isEnabled = await _isNotificationTypeEnabled(notificationType);

    if (isEnabled) {
      await _showLocalNotification(message);
    } else {
      AppLogger.info('Notification type is disabled by user');
    }

    await _saveNotificationToDatabase(message);
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    AppLogger.info('Notification tapped');
    _navigateToScreen(message.data);
  }

  // ✅ دالة عرض الإشعار المحلي (بدون priority و enableVibration)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'hirfati_channel',
          'Hirfati Notifications',
          channelDescription: 'قناة إشعارات تطبيق Hirfati',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    try {
      await _localNotifications.show(
        id: id,
        title: message.notification?.title ?? 'Hirfati',
        body: message.notification?.body ?? 'لديك إشعار جديد',
        payload: message.data.toString(),
        notificationDetails: details,
      );
      AppLogger.info('Local notification shown');
    } catch (error, stackTrace) {
      AppLogger.error(
        error,
        stackTrace: stackTrace,
        message: 'Unable to show local notification',
      );
    }
  }

  static Future<void> _saveNotificationToDatabase(RemoteMessage message) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      await supabase.from('notifications').insert({
        'user_id': user.id,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'type': message.data['type'] ?? 'system',
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Notification saved');
    }
  }

  static void _navigateToScreen(Map<String, dynamic> data) {
    AppLogger.info('Notification navigation requested');
  }

  static void _onNotificationTap(NotificationResponse response) {
    AppLogger.info('Local notification tapped');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.info('Background notification received');

  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user != null) {
    final notificationType = message.data['type'] ?? 'push';
    final isEnabled = await _isNotificationTypeEnabled(notificationType);

    if (isEnabled) {
      await supabase.from('notifications').insert({
        'user_id': user.id,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'type': message.data['type'] ?? 'system',
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Background notification saved');
    } else {
      AppLogger.info('Background notification type is disabled');
    }
  }
}
