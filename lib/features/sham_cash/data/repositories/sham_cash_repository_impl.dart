import '../../domain/models/sham_cash_account_model.dart';
import '../../domain/models/sham_cash_transaction_model.dart';
import '../../domain/repositories/sham_cash_repository.dart';
import '../datasources/sham_cash_supabase_datasource.dart';

class ShamCashRepositoryImpl implements ShamCashRepository {
  final ShamCashSupabaseDatasource _datasource;

  ShamCashRepositoryImpl(this._datasource);

  @override
  Future<ShamCashAccountModel?> getMyAccount() {
    return _datasource.getMyAccount();
  }

  @override
  Future<double> getBalance() {
    return _datasource.getBalance();
  }

  @override
  Future<List<ShamCashTransactionModel>> getMyTransactions({int limit = 50}) {
    return _datasource.getMyTransactions(limit: limit);
  }
}
