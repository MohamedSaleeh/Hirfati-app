import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/help_support_supabase_datasource.dart';
import '../repositories/help_support_repository_impl.dart';
import '../../domain/repositories/help_support_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final helpSupportDatasourceProvider = Provider<HelpSupportSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return HelpSupportSupabaseDatasource(client);
});

final helpSupportRepositoryProvider = Provider<HelpSupportRepository>((ref) {
  final datasource = ref.watch(helpSupportDatasourceProvider);
  return HelpSupportRepositoryImpl(datasource);
});