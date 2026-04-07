import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/worker_profile_providers.dart';
import '../../domain/models/worker_profile_model.dart';
import '../../domain/repositories/worker_profile_repository.dart';


class WorkerProfileNotifier extends StateNotifier<AsyncValue<WorkerProfileModel>> {
  final WorkerProfileRepository _repository;
  final String _userId;

  WorkerProfileNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadProfile() async {
    state = const AsyncLoading();
    try {
      final profile = await _repository.getWorkerProfile(_userId);
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final workerProfileProvider = StateNotifierProvider<WorkerProfileNotifier, AsyncValue<WorkerProfileModel>>((ref) {
  final repository = ref.watch(workerProfileRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  final notifier = WorkerProfileNotifier(repository, user.id);
  notifier.loadProfile();
  return notifier;
});