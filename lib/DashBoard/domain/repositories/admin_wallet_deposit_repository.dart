import '../../models/admin_wallet_deposit_models.dart';

abstract class AdminWalletDepositRepository {
  Future<double> getBalance(String userId);
  Future<AdminWalletDepositResult> deposit(AdminWalletDepositRequest request);
}
