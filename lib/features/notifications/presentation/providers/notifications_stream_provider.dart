// lib/features/notifications/presentation/providers/notifications_stream_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/notifications_providers.dart';
import '../../domain/models/notification_model.dart';


final notificationsStreamProvider = StreamProvider<List<NotificationModel>>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;
  
  if (user == null) throw Exception('User not authenticated');
  
  final controller = StreamController<List<NotificationModel>>();
  
  Future<void> fetchNotifications() async {
    try {
      final notifications = await repository.getNotifications(user.id);
      if (!controller.isClosed) {
        controller.add(notifications);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }
  
  fetchNotifications();
  
  final timer = Timer.periodic(const Duration(seconds: 30), (_) {
    fetchNotifications();
  });
  
  final subscription = supabaseClient
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .listen((data) {
    fetchNotifications(); 
  });
  
  ref.onDispose(() {
    timer.cancel();
    subscription.cancel();
    controller.close();
  });
  
  return controller.stream;
});

final unreadNotificationsCountStreamProvider = StreamProvider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsStreamProvider);
  
  final controller = StreamController<int>();
  
  final subscription = notificationsAsync.whenData((notifications) {
    final unreadCount = notifications.where((n) => !n.isRead).length;
    controller.add(unreadCount);
  });
  
  ref.onDispose(() {
    controller.close();
  });
  
  return controller.stream;
});