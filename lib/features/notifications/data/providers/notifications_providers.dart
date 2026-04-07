import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/notifications_supabase_datasource.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../repositories/notifications_repository_impl.dart';

// Provider لـ SupabaseClient
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider لـ Datasource
final notificationsDatasourceProvider = Provider<NotificationsSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return NotificationsSupabaseDatasource(client);
});

// Provider لـ Repository
final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  final datasource = ref.watch(notificationsDatasourceProvider);
  return NotificationsRepositoryImpl(datasource);
});