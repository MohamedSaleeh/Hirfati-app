import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/incoming_orders_supabase_datasource.dart';
import '../repositories/incoming_orders_repository_impl.dart';
import '../../domain/repositories/incoming_orders_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final incomingOrdersDatasourceProvider = Provider<IncomingOrdersSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return IncomingOrdersSupabaseDatasource(client);
});

final incomingOrdersRepositoryProvider = Provider<IncomingOrdersRepository>((ref) {
  final datasource = ref.watch(incomingOrdersDatasourceProvider);
  return IncomingOrdersRepositoryImpl(datasource);
});