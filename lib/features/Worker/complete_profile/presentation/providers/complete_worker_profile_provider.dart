import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/worker_profile_repository_impl.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/worker_profile_model.dart';

/// Provider to load the list of professions (categories) from Supabase.
final workerCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.read(workerProfileRepositoryProvider).getCategories();
});

/// Provider to handle the submission state of the complete profile form.
final completeWorkerProfileProvider =
    AsyncNotifierProvider<CompleteWorkerProfileNotifier, void>(
  CompleteWorkerProfileNotifier.new,
);

class CompleteWorkerProfileNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is data(null)
  }

  /// Submits the worker profile to Supabase.
  Future<bool> submitProfile(WorkerProfileModel profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(workerProfileRepositoryProvider).submitProfile(profile);
    });
    return !state.hasError;
  }
}
