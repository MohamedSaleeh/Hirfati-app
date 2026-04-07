import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  } catch (e) {
    print('Error checking notification settings: $e');
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

    // الحصول على FCM Token
    await _getToken();

    // ربط معالج الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // ربط معالج المقدمة
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // ربط معالج الضغط على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    print('✅ Notification Service initialized successfully');
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

      print('✅ Notification channel created');
    }
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Notification permission status: ${settings.authorizationStatus}');
  }

  static Future<void> _getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');

    if (token != null) {
      await _saveTokenToSupabase(token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('Token refreshed: $newToken');
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
      print('✅ Token saved successfully');
    } catch (e) {
      print('❌ Insert failed: $e');

      if (e.toString().contains('23505')) {
        try {
          await supabase
              .from('device_tokens')
              .update({
                'user_id': user.id,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('fcm_token', token);
          print('✅ Token updated successfully');
        } catch (e2) {
          print('❌ Update failed: $e2');
        }
      }
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) async {
    print('🔔🔔🔔 [CLIENT] Foreground message received! 🔔🔔🔔');
    print('📱 Title: ${message.notification?.title}');
    print('📱 Body: ${message.notification?.body}');
    print('📱 Data: ${message.data}');

    final notificationType = message.data['type'] ?? 'push';
    final isEnabled = await _isNotificationTypeEnabled(notificationType);

    if (isEnabled) {
      await _showLocalNotification(message);
    } else {
      print('⚠️ Notification type "$notificationType" is disabled by user');
    }

    await _saveNotificationToDatabase(message);
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    print('🔔 Notification tapped: ${message.data}');
    _navigateToScreen(message.data);
  }

  // ✅ دالة عرض الإشعار المحلي (بدون priority و enableVibration)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    print('📢 Showing local notification...');

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
      print('✅ Local notification shown with id: $id');
    } catch (e) {
      print('❌ Failed to show notification: $e');
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
      print('💾 Notification saved to database');
    }
  }

  static void _navigateToScreen(Map<String, dynamic> data) {
    print('Navigate to: ${data['type']}');
  }

  static void _onNotificationTap(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📱 Background message received: ${message.messageId}");

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
      print('💾 Background notification saved to database');
    } else {
      print('⚠️ Background notification type "$notificationType" is disabled');
    }
  }
}
