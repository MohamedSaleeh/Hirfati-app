import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/providers/pin_providers.dart';
import '../../domain/repositories/pin_repository.dart';

class PinNotifier extends StateNotifier<AsyncValue<bool>> {
  final PinRepository _repository;
  final String _userId;

  PinNotifier(this._repository, this._userId) : super(const AsyncData(false));

  Future<bool> hasPin() async {
    return await _repository.hasPin(_userId);
  }

  Future<void> setPin(String pin) async {
    state = const AsyncLoading();
    try {
      await _repository.setPin(_userId, pin);

      state = const AsyncData(true);
    } catch (e, st) {
      state = AsyncError(e, st);

      rethrow;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      return await _repository.verifyPin(_userId, pin);
    } catch (e) {
      print('PIN verification error: $e');
      return false;
    }
  }

  Future<void> changePin(String oldPin, String newPin) async {
    state = const AsyncLoading();
    try {
      await _repository.changePin(_userId, oldPin, newPin);
      state = const AsyncData(true);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> resetPin() async {
    state = const AsyncLoading();
    try {
      await _repository.resetPin(_userId);
      state = const AsyncData(true);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<int> getRemainingAttempts() async {
    return await _repository.getRemainingAttempts(_userId);
  }
}

final pinProvider = StateNotifierProvider<PinNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(pinRepositoryProvider);
  final supabase = ref.watch(supabaseClientProvider);
  final user = supabase.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  return PinNotifier(repository, user.id);
});

final hasPinProvider = FutureProvider<bool>((ref) async {
  final notifier = ref.watch(pinProvider.notifier);
  return await notifier.hasPin();
});
