import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_supabase_datasource.dart';
import '../repositories/wallet_repository_impl.dart';

final walletSupabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final walletDatasourceProvider = Provider<WalletSupabaseDatasource>((ref) {
  final client = ref.watch(walletSupabaseClientProvider);
  return WalletSupabaseDatasource(client);
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final datasource = ref.watch(walletDatasourceProvider);
  return WalletRepositoryImpl(datasource);
});
