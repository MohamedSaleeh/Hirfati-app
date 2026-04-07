import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/worker_home_providers.dart';
import '../../domain/repositories/worker_home_repository.dart';

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, bool>((ref) {
  final repo = ref.read(workerHomeRepositoryProvider);
  return AvailabilityNotifier(repo);
});

class AvailabilityNotifier extends StateNotifier<bool> {
  final WorkerHomeRepository _repo;

  AvailabilityNotifier(this._repo) : super(false) {
    _init();
  }

  Future<void> _init() async {
    try {
      state = await _repo.getAvailability();
    } catch (_) {
      // Initial fetch failed, state remains false.
    }
  }

  Future<void> toggleAvailability(bool isAvailable) async {
    final previousState = state;
    state = isAvailable; // Optimistic update
    try {
      await _repo.setAvailability(isAvailable);
    } catch (e) {
      state = previousState; // Revert on failure
      rethrow;
    }
  }
}
