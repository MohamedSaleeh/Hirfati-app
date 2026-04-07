import 'package:flutter_riverpod/legacy.dart';

import '../../domain/repositories/worker_profile_repository.dart';
import '../../data/providers/worker_profile_providers.dart';
import '../../domain/models/worker_profile_state.dart';

final workerProfileControllerProvider = StateNotifierProvider.family<
    WorkerProfileController, WorkerProfileState, String>((ref, workerId) {
  final repo = ref.watch(workerProfileRepositoryProvider);
  return WorkerProfileController(repo)..load(workerId);
});

class WorkerProfileController extends StateNotifier<WorkerProfileState> {
  final WorkerProfileRepository _repo;

  WorkerProfileController(this._repo) : super(const WorkerProfileState());

  Future<void> load(String workerId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final details = await _repo.getWorkerDetails(workerId);
      final portfolio = await _repo.getWorkerPortfolio(workerId, limit: 4);
      final services = await _repo.getWorkerServices(workerId);
      final reviews = await _repo.getWorkerReviews(workerId, limit: 5);

      state = state.copyWith(
        isLoading: false,
        details: details,
        portfolio: portfolio,
        services: services,
        reviews: reviews,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> toggleFavorite(String workerId) async {
    final current = state.details;
    if (current == null) return;

    final newValue = !current.isFavorite;
    state = state.copyWith(details: current.copyWith(isFavorite: newValue));

    try {
      await _repo.toggleFavorite(workerId);
    } catch (_) {
      state = state.copyWith(details: current);
    }
  }
}