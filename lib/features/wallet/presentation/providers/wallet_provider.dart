import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/wallet_providers.dart';
import '../../domain/models/wallet_models.dart';

class WalletUnauthenticatedException implements Exception {
  const WalletUnauthenticatedException();

  @override
  String toString() => 'User not authenticated';
}

final walletProvider = FutureProvider.autoDispose<WalletData>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  final supabaseClient = ref.watch(walletSupabaseClientProvider);
  final user = supabaseClient.auth.currentUser;

  if (user == null) {
    throw const WalletUnauthenticatedException();
  }

  return repository.getWalletData(user.id);
});

final paymentEventsProvider = FutureProvider.autoDispose
    .family<List<WalletPaymentEvent>, String>((ref, paymentId) async {
      final repository = ref.watch(walletRepositoryProvider);
      final supabaseClient = ref.watch(walletSupabaseClientProvider);
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        throw const WalletUnauthenticatedException();
      }

      return repository.getPaymentEvents(userId: user.id, paymentId: paymentId);
    });
