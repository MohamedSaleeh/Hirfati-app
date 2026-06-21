import '../models/earnings_summary_model.dart';
import '../models/transaction_model.dart';

abstract class EarningsRepository {
  Future<EarningsSummaryModel> getEarningsSummary(String userId);
  Future<List<TransactionModel>> getRecentTransactions(
    String userId, {
    int limit = 10,
  });
  

  

  Future<void> requestWithdrawal({
    required String userId,
    required double amount,
    required String bankName,
    required String accountNumber,
  });
  
  Future<List<TransactionModel>> getWithdrawalHistory(String userId);
  Future<double> getAvailableBalance(String userId);
  Future<void> updateAvailableBalance(String userId, double newBalance);
}