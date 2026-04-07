import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/review_supabase_datasource.dart';
import '../repositories/review_repository_impl.dart';
import '../../domain/repositories/review_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final reviewDatasourceProvider = Provider<ReviewSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ReviewSupabaseDatasource(client);
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final datasource = ref.watch(reviewDatasourceProvider);
  return ReviewRepositoryImpl(datasource);
});