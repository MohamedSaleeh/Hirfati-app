import '../../domain/models/wallet_models.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_supabase_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletSupabaseDatasource _datasource;

  WalletRepositoryImpl(this._datasource);

  @override
  Future<WalletData> getWalletData(String userId) async {
    final walletFuture = _datasource.getWallet(userId);
    final paymentsFuture = _datasource.getPayments(userId);

    final wallet = await walletFuture;
    final payments = await paymentsFuture;

    return WalletData(
      wallet: wallet ?? WalletAccount.empty(userId),
      walletExists: wallet != null,
      payments: payments,
    );
  }

  @override
  Future<List<WalletPaymentEvent>> getPaymentEvents({
    required String userId,
    required String paymentId,
  }) async {
    return _datasource.getPaymentEvents(userId: userId, paymentId: paymentId);
  }
}
