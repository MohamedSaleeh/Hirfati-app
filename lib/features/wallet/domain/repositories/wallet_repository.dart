import '../models/wallet_models.dart';

abstract class WalletRepository {
  Future<WalletData> getWalletData(String userId);

  Future<List<WalletPaymentEvent>> getPaymentEvents({
    required String userId,
    required String paymentId,
  });
}
