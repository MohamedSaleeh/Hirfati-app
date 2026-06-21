import '../../domain/models/earnings_summary_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/earnings_repository.dart';
import '../datasources/earnings_supabase_datasource.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  final EarningsSupabaseDatasource _datasource;

  EarningsRepositoryImpl(this._datasource);

  @override
  Future<EarningsSummaryModel> getEarningsSummary(String userId) async {
    return await _datasource.getEarningsSummary(userId);
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions(
    String userId, {
    int limit = 10,
  }) async {
    return await _datasource.getRecentTransactions(userId, limit: limit);
  }



  // ⚠️ تم تعطيلها
  @override
  Future<void> requestWithdrawal({
    required String userId,
    required double amount,
    required String bankName,
    required String accountNumber,
  }) async {
    await _datasource.requestWithdrawal(
      userId: userId,
      amount: amount,
      bankName: bankName,
      accountNumber: accountNumber,
    );
  }

  @override
  Future<List<TransactionModel>> getWithdrawalHistory(String userId) async {
    return await _datasource.getWithdrawalHistory(userId);
  }

  @override
  Future<double> getAvailableBalance(String userId) async {
    return await _datasource.getAvailableBalance(userId);
  }

  @override
  Future<void> updateAvailableBalance(String userId, double newBalance) async {
    await _datasource.updateAvailableBalance(userId, newBalance);
  }
}
