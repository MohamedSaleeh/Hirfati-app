import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/addresses_supabase_datasource.dart';
import '../repositories/addresses_repository_impl.dart';
import '../../domain/repositories/addresses_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final addressesDatasourceProvider = Provider<AddressesSupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AddressesSupabaseDatasource(client);
});

final addressesRepositoryProvider = Provider<AddressesRepository>((ref) {
  final datasource = ref.watch(addressesDatasourceProvider);
  return AddressesRepositoryImpl(datasource);
});