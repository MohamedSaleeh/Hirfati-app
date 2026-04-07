import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/categories_pricing_supabase_datasource.dart';
import '../repositories/categories_pricing_repository_impl.dart';
import '../../domain/repositories/categories_pricing_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final categoriesPricingDatasourceProvider = Provider<CategoriesPricingSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CategoriesPricingSupabaseDatasource(client);
});

final categoriesPricingRepositoryProvider = Provider<CategoriesPricingRepository>((ref) {
  final datasource = ref.watch(categoriesPricingDatasourceProvider);
  return CategoriesPricingRepositoryImpl(datasource);
});