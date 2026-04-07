import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/notification_settings_providers.dart';
import '../../domain/models/notification_settings_model.dart';
import '../../domain/repositories/notification_settings_repository.dart';

class NotificationSettingsNotifier extends StateNotifier<AsyncValue<NotificationSettingsModel>> {
  final NotificationSettingsRepository _repository;
  final String _userId;

  NotificationSettingsNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadSettings() async {
    state = const AsyncLoading();
    try {
      final settings = await _repository.getSettings(_userId);
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updatePushEnabled(bool value) async {
    state.whenData((current) async {
      try {
        await _repository.updatePushEnabled(_userId, value);
        state = AsyncData(current.copyWith(pushEnabled: value));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> updateEmailEnabled(bool value) async {
    state.whenData((current) async {
      try {
        await _repository.updateEmailEnabled(_userId, value);
        state = AsyncData(current.copyWith(emailEnabled: value));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> updateSmsEnabled(bool value) async {
    state.whenData((current) async {
      try {
        await _repository.updateSmsEnabled(_userId, value);
        state = AsyncData(current.copyWith(smsEnabled: value));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> updateOrderConfirmation(bool value) async {
    state.whenData((current) async {
      try {
        await _repository.updateOrderConfirmation(_userId, value);
        state = AsyncData(current.copyWith(orderConfirmation: value));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> updateOrderStatus(bool value) async {
    state.whenData((current) async {
      try {
        await _repository.updateOrderStatus(_userId, value);
        state = AsyncData(current.copyWith(orderStatus: value));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> updatePromotions(bool value) async {
    state.whenData((current) async {
      try {
        await _repository.updatePromotions(_userId, value);
        state = AsyncData(current.copyWith(promotions: value));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }
}

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, AsyncValue<NotificationSettingsModel>>((ref) {
  final repository = ref.watch(notificationSettingsRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;
  
  if (user == null) throw Exception('User not authenticated');
  
  final notifier = NotificationSettingsNotifier(repository, user.id);
  notifier.loadSettings();
  return notifier;
});