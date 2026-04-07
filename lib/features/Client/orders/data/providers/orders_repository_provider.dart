// lib/data/providers/orders_repository_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/orders_supabase_datasource.dart';
import '../repositories/orders_repository_impl.dart';

// Provider لـ SupabaseClient
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider لـ OrdersSupabaseDatasource
final ordersSupabaseDatasourceProvider = Provider<OrdersSupabaseDatasource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return OrdersSupabaseDatasource(supabaseClient);
});

// Provider لـ OrdersRepositoryImpl
final ordersRepositoryProvider = Provider<OrdersRepositoryImpl>((ref) {
  final datasource = ref.watch(ordersSupabaseDatasourceProvider);
  return OrdersRepositoryImpl(datasource);
});