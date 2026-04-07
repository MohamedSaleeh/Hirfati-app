// lib/features/notifications/presentation/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/notifications_providers.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';


class NotificationsNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationsRepository _repository;
  final String _userId;

  NotificationsNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadNotifications() async {
    state = const AsyncLoading();
    try {
      final notifications = await _repository.getNotifications(_userId);
      state = AsyncData(notifications);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    state.whenData((notifications) async {
      try {
        await _repository.markAsRead(notificationId);
        final updatedList = notifications.map((n) {
          return n.id == notificationId ? n.copyWith(isRead: true) : n;
        }).toList();
        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> markAllAsRead() async {
    state.whenData((notifications) async {
      try {
        await _repository.markAllAsRead(_userId);
        final updatedList = notifications.map((n) => n.copyWith(isRead: true)).toList();
        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    state.whenData((notifications) async {
      try {
        await _repository.deleteNotification(notificationId);
        final updatedList = notifications.where((n) => n.id != notificationId).toList();
        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<int> getUnreadCount() async {
    return await _repository.getUnreadCount(_userId);
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;
  
  if (user == null) throw Exception('User not authenticated');
  
  final notifier = NotificationsNotifier(repository, user.id);
  notifier.loadNotifications();
  return notifier;
});

final unreadNotificationsCountProvider = FutureProvider<int>((ref) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getUnreadCount();
});