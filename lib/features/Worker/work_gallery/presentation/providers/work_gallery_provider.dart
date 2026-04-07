import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/work_gallery_providers.dart';
import '../../domain/models/work_category_model.dart';
import '../../domain/models/work_item_model.dart';
import '../../domain/repositories/work_gallery_repository.dart';

class WorkGalleryNotifier extends StateNotifier<AsyncValue<List<WorkItemModel>>> {
  final WorkGalleryRepository _repository;
  final String _userId;

  WorkGalleryNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadWorkItems() async {
    state = const AsyncLoading();
    try {
      final items = await _repository.getWorkItems(_userId);
      state = AsyncData(items);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addWorkItem({
    required String title,
    required String description,
    required List<String> imageUrls,
    required String category,
    required String complexity,
  }) async {
    state.whenData((current) async {
      try {
        state = const AsyncLoading();
        
        final workerId = await _repository.getWorkerId(_userId);
        if (workerId == null) throw Exception('Worker not found');

        final newItem = await _repository.addWorkItem(
          workerId: workerId,
          title: title,
          description: description,
          imageUrls: imageUrls,
          category: category,
          complexity: complexity,
        );
        state = AsyncData([newItem, ...current]);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> deleteWorkItem(String workId) async {
    state.whenData((current) async {
      try {
        state = const AsyncLoading();
        await _repository.deleteWorkItem(workId);
        state = AsyncData(current.where((item) => item.id != workId).toList());
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }
}

final workGalleryProvider = StateNotifierProvider<WorkGalleryNotifier, AsyncValue<List<WorkItemModel>>>((ref) {
  final repository = ref.watch(workGalleryRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  final notifier = WorkGalleryNotifier(repository, user.id);
  notifier.loadWorkItems();
  return notifier;
});

final workCategoriesProvider = FutureProvider<List<WorkCategoryModel>>((ref) async {
  final repository = ref.watch(workGalleryRepositoryProvider);
  return repository.getCategories();
});