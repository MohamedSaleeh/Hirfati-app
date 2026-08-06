import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/map_remote_datasource.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/repositories/map_repository.dart';
import '../../../Home_client/data/repositories/home_client_repo_provider.dart';
import '../../../Home_client/domain_models/category_model.dart';
import '../../../Home_client/domain_models/craftsman_model.dart';
import '../../../Home_client/presentation/providers/search_craftsmen_provider.dart';

// --- Data Injection ---
final mapDatasourceProvider = Provider<MapRemoteDatasource>((ref) {
  return MapSupabaseDatasourceImpl(Supabase.instance.client);
});

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(ref.read(mapDatasourceProvider));
});

// --- State Providers ---
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedMarkerProvider = StateProvider<String?>((ref) => null);

// --- Async Data Providers ---
final mapCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.watch(homeClientRepositoryProvider).getCategories();
});

final rawMapWorkersProvider = FutureProvider<List<CraftsmanModel>>((ref) {
  return ref.watch(mapRepositoryProvider).getNearbyCraftsmen();
});

// --- Filtered Computed Provider ---
final nearbyWorkersProvider = Provider<AsyncValue<List<CraftsmanModel>>>((ref) {
  final rawAsync = ref.watch(rawMapWorkersProvider);
  final searchQuery = ref.watch(searchQueryProvider).trim();
  final selectedCategoryId = ref.watch(selectedCategoryProvider);
  final searchAsync = searchQuery.isEmpty
      ? null
      : ref.watch(searchCraftsmenProvider(searchQuery));

  return rawAsync.whenData((list) {
    final matchingSearchIds = searchQuery.isEmpty
        ? null
        : searchAsync?.maybeWhen(
            data: (results) => results.map((worker) => worker.id).toSet(),
            orElse: () => null,
          );

    return list.where((c) {
      final matchesSearch =
          searchQuery.isEmpty ||
          matchingSearchIds == null ||
          matchingSearchIds.contains(c.id);
      final matchesCategory =
          selectedCategoryId == null || c.categoryId == selectedCategoryId;

      return matchesSearch && matchesCategory;
    }).toList();
  });
});
