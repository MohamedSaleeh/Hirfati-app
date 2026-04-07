import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/categories_pricing_providers.dart';
import '../../domain/models/worker_category_model.dart';
import '../../domain/models/worker_service_model.dart';
import '../../domain/repositories/categories_pricing_repository.dart';

class CategoriesPricingNotifier extends StateNotifier<AsyncValue<(List<WorkerCategoryModel>, List<WorkerServiceModel>)>> {
  final CategoriesPricingRepository _repository;
  final String _userId;

  CategoriesPricingNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadData() async {
    state = const AsyncLoading();
    try {
      final workerId = await _repository.getWorkerId(_userId);
      if (workerId == null) throw Exception('Worker not found');
      
      final results = await Future.wait([
        _repository.getWorkerCategories(_userId),
        _repository.getWorkerServices(workerId),
      ]);
      
      state = AsyncData((results[0], results[1]) as (List<WorkerCategoryModel>, List<WorkerServiceModel>));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updatePriceRange(double priceMin, double priceMax) async {
    state.whenData((data) async {
      try {
        state = const AsyncLoading();
        final workerId = await _repository.getWorkerId(_userId);
        if (workerId == null) throw Exception('Worker not found');
        
        final categoryId = data.$1.first.id;
        await _repository.updateCategoryPriceRange(workerId, categoryId, priceMin, priceMax);
        
        final updatedCategories = data.$1.map((c) {
          return c.copyWith(priceMin: priceMin, priceMax: priceMax);
        }).toList();
        
        state = AsyncData((updatedCategories, data.$2));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> addService({
    required String title,
    required double price,
    String? description,
    int? durationMinutes,
  }) async {
    state.whenData((data) async {
      try {
        state = const AsyncLoading();
        final workerId = await _repository.getWorkerId(_userId);
        if (workerId == null) throw Exception('Worker not found');
        
        final newService = await _repository.addService(
          workerId,
          title,
          price,
          description,
          durationMinutes,
        );
        
        state = AsyncData((data.$1, [...data.$2, newService]));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> updateService(WorkerServiceModel service) async {
    state.whenData((data) async {
      try {
        state = const AsyncLoading();
        final updated = await _repository.updateService(service);
        final updatedServices = data.$2.map((s) => s.id == updated.id ? updated : s).toList();
        state = AsyncData((data.$1, updatedServices));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> deleteService(String serviceId) async {
    state.whenData((data) async {
      try {
        state = const AsyncLoading();
        await _repository.deleteService(serviceId);
        final remainingServices = data.$2.where((s) => s.id != serviceId).toList();
        state = AsyncData((data.$1, remainingServices));
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }
}

final categoriesPricingProvider = StateNotifierProvider<CategoriesPricingNotifier, AsyncValue<(List<WorkerCategoryModel>, List<WorkerServiceModel>)>>((ref) {
  final repository = ref.watch(categoriesPricingRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  final notifier = CategoriesPricingNotifier(repository, user.id);
  notifier.loadData();
  return notifier;
});