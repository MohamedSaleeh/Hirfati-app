import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/notification_settings_supabase_datasource.dart';
import '../repositories/notification_settings_repository_impl.dart';
import '../../domain/repositories/notification_settings_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final notificationSettingsDatasourceProvider = Provider<NotificationSettingsSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return NotificationSettingsSupabaseDatasource(client);
});

final notificationSettingsRepositoryProvider = Provider<NotificationSettingsRepository>((ref) {
  final datasource = ref.watch(notificationSettingsDatasourceProvider);
  return NotificationSettingsRepositoryImpl(datasource);
});