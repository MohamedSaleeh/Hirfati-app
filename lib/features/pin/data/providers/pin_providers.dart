import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/pin_supabase_datasource.dart';
import '../repositories/pin_repository_impl.dart';
import '../../domain/repositories/pin_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final pinDatasourceProvider = Provider<PinSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PinSupabaseDatasource(client);
});

final pinRepositoryProvider = Provider<PinRepository>((ref) {
  final datasource = ref.watch(pinDatasourceProvider);
  return PinRepositoryImpl(datasource);
});