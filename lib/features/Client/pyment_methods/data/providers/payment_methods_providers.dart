import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/payment_methods_supabase_datasource.dart';
import '../repositories/payment_methods_repository_impl.dart';
import '../../domain/repositories/payment_methods_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final paymentMethodsDatasourceProvider = Provider<PaymentMethodsSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PaymentMethodsSupabaseDatasource(client);
});

final paymentMethodsRepositoryProvider = Provider<PaymentMethodsRepository>((ref) {
  final datasource = ref.watch(paymentMethodsDatasourceProvider);
  return PaymentMethodsRepositoryImpl(datasource);
});