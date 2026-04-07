import '../../domain/models/sham_cash_account_model.dart';
import '../../domain/models/sham_cash_transaction_model.dart';

abstract class ShamCashRepository {
  Future<ShamCashAccountModel?> getMyAccount();
  Future<double> getBalance();
  Future<List<ShamCashTransactionModel>> getMyTransactions({int limit});
}
