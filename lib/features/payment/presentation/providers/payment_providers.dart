import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/payment_supabase_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final paymentDatasourceProvider = Provider<PaymentSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PaymentSupabaseDatasource(client);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final datasource = ref.watch(paymentDatasourceProvider);
  return PaymentRepositoryImpl(datasource);
});