import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/identity_verification_supabase_datasource.dart';
import '../repositories/identity_verification_repository_impl.dart';
import '../../domain/repositories/identity_verification_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final identityVerificationDatasourceProvider = Provider<IdentityVerificationSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return IdentityVerificationSupabaseDatasource(client);
});

final identityVerificationRepositoryProvider = Provider<IdentityVerificationRepository>((ref) {
  final datasource = ref.watch(identityVerificationDatasourceProvider);
  return IdentityVerificationRepositoryImpl(datasource);
});