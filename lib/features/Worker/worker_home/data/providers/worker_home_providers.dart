import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/worker_home_remote_datasource.dart';
import '../repositories/worker_home_repository_impl.dart';
import '../../domain/repositories/worker_home_repository.dart';

// ✅ Provider لـ SupabaseClient
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ✅ Provider لـ Datasource
final workerHomeRemoteDatasourceProvider = Provider<WorkerHomeRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WorkerHomeRemoteDatasourceImpl(client);
});

// ✅ Provider لـ Repository
final workerHomeRepositoryProvider = Provider<WorkerHomeRepository>((ref) {
  final datasource = ref.watch(workerHomeRemoteDatasourceProvider);
  return WorkerHomeRepositoryImpl(datasource);
});