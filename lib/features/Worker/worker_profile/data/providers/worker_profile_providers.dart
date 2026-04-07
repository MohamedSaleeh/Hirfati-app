import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/worker_profile_supabase_datasource.dart';
import '../repositories/worker_profile_repository_impl.dart';
import '../../domain/repositories/worker_profile_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final workerProfileDatasourceProvider = Provider<WorkerProfileSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WorkerProfileSupabaseDatasource(client);
});

final workerProfileRepositoryProvider = Provider<WorkerProfileRepository>((ref) {
  final datasource = ref.watch(workerProfileDatasourceProvider);
  return WorkerProfileRepositoryImpl(datasource);
});