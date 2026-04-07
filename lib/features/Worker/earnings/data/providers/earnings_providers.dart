import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/earnings_supabase_datasource.dart';
import '../repositories/earnings_repository_impl.dart';
import '../../domain/repositories/earnings_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final earningsDatasourceProvider = Provider<EarningsSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return EarningsSupabaseDatasource(client);
});

final earningsRepositoryProvider = Provider<EarningsRepository>((ref) {
  final datasource = ref.watch(earningsDatasourceProvider);
  return EarningsRepositoryImpl(datasource);
});