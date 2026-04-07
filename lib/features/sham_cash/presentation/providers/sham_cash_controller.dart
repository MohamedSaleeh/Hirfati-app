import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/sham_cash_providers.dart';
import '../../domain/models/sham_cash_account_model.dart';
import '../../domain/models/sham_cash_transaction_model.dart';

class ShamCashController {
  final Ref _ref;

  ShamCashController(this._ref);

  Future<ShamCashAccountModel?> getMyAccount() async {
    final repository = _ref.read(shamCashRepositoryProvider);
    return await repository.getMyAccount();
  }

  Future<double> getBalance() async {
    final repository = _ref.read(shamCashRepositoryProvider);
    return await repository.getBalance();
  }

  Future<List<ShamCashTransactionModel>> getMyTransactions({
    int limit = 50,
  }) async {
    final repository = _ref.read(shamCashRepositoryProvider);
    return await repository.getMyTransactions(limit: limit);
  }

  void refresh() {
    _ref.invalidate(shamCashAccountProvider);
    _ref.invalidate(shamCashTransactionsProvider);
  }
}

final shamCashControllerProvider = Provider<ShamCashController>((ref) {
  return ShamCashController(ref);
});
