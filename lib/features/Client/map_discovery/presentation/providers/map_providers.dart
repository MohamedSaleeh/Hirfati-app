import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/map_remote_datasource.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/repositories/map_repository.dart';
import '../../../Home_client/domain_models/craftsman_model.dart';
import '../../../Home_client/domain_models/category_model.dart';

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
  return ref.watch(mapRepositoryProvider).getCategories();
});

final rawMapWorkersProvider = FutureProvider<List<CraftsmanModel>>((ref) {
  return ref.watch(mapRepositoryProvider).getNearbyCraftsmen();
});

// --- Filtered Computed Provider ---
final nearbyWorkersProvider = Provider<AsyncValue<List<CraftsmanModel>>>((ref) {
  final rawAsync = ref.watch(rawMapWorkersProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return rawAsync.whenData((list) {
    return list.where((c) {
      if (selectedCategory != null && selectedCategory.isNotEmpty) {
        if (c.profession != selectedCategory) return false;
      }
      if (searchQuery.isNotEmpty) {
        if (!c.name.toLowerCase().contains(searchQuery) &&
            !(c.profession?.toLowerCase().contains(searchQuery) ?? false)) {
          return false;
        }
      }
      return true;
    }).toList();
  });
});
