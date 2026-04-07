import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain_models/category_model.dart';
import '../../domain_models/craftsman_model.dart';
import '../datasources/home_client_supabase_datasource.dart';
import 'home_client_repository.dart';

// ------------------------------------------------------------------
// Provider
// ------------------------------------------------------------------

final homeClientRepositoryProvider = Provider<HomeClientRepository>((ref) {
  return HomeClientRepositoryImpl(
    HomeClientSupabaseDatasource(Supabase.instance.client),
  );
});

// ------------------------------------------------------------------
// Implementation
// ------------------------------------------------------------------

class HomeClientRepositoryImpl implements HomeClientRepository {
  final HomeClientSupabaseDatasource _datasource;

  HomeClientRepositoryImpl(this._datasource);

  @override
  Future<List<CategoryModel>> getCategories() =>
      _datasource.fetchCategories();

  @override
  Future<List<CraftsmanModel>> getRecommendedCraftsmen() =>
      _datasource.fetchRecommendedCraftsmen();

  @override
  Future<List<CraftsmanModel>> searchCraftsmen(String query) =>
      _datasource.searchCraftsmen(query);

  @override
  Future<List<CraftsmanModel>> getNearbyCraftsmen() =>
      _datasource.fetchNearbyCraftsmen();

  @override
  Future<String?> getUserCity() => _datasource.fetchUserCity();
}
