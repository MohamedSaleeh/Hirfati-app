import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/sham_cash_supabase_datasource.dart';
import '../repositories/sham_cash_repository_impl.dart';
import '../../domain/repositories/sham_cash_repository.dart';
import '../../domain/models/sham_cash_account_model.dart';
import '../../domain/models/sham_cash_transaction_model.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final shamCashDatasourceProvider = Provider<ShamCashSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ShamCashSupabaseDatasource(client);
});

final shamCashRepositoryProvider = Provider<ShamCashRepository>((ref) {
  final datasource = ref.watch(shamCashDatasourceProvider);
  return ShamCashRepositoryImpl(datasource);
});

// Provider لعرض حساب شام كاش
final shamCashAccountProvider = FutureProvider<ShamCashAccountModel?>((ref) {
  final repository = ref.watch(shamCashRepositoryProvider);
  return repository.getMyAccount();
});

// Provider لعرض المعاملات
final shamCashTransactionsProvider =
    FutureProvider<List<ShamCashTransactionModel>>((ref) {
      final repository = ref.watch(shamCashRepositoryProvider);
      return repository.getMyTransactions(limit: 50);
    });
