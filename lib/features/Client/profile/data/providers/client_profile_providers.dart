import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/client_profile_supabase_datasource.dart';
import '../repositories/client_profile_repository_impl.dart';
import '../../domain/repositories/client_profile_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final clientProfileDatasourceProvider = Provider<ClientProfileSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ClientProfileSupabaseDatasource(client);
});

final clientProfileRepositoryProvider = Provider<ClientProfileRepository>((ref) {
  final datasource = ref.watch(clientProfileDatasourceProvider);
  return ClientProfileRepositoryImpl(datasource);
});