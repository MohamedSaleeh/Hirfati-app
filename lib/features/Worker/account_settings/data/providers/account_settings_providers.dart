import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/account_settings_supabase_datasource.dart';
import '../repositories/account_settings_repository_impl.dart';
import '../../domain/repositories/account_settings_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final accountSettingsDatasourceProvider = Provider<AccountSettingsSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AccountSettingsSupabaseDatasource(client);
});

final accountSettingsRepositoryProvider = Provider<AccountSettingsRepository>((ref) {
  final datasource = ref.watch(accountSettingsDatasourceProvider);
  return AccountSettingsRepositoryImpl(datasource);
});