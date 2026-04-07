import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/earnings_providers.dart';
import '../../domain/models/earnings_summary_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/earnings_repository.dart';

class EarningsNotifier
    extends
        StateNotifier<
          AsyncValue<(EarningsSummaryModel, List<TransactionModel>)>
        > {
  final EarningsRepository _repository;
  final String _userId;
  bool _isDisposed = false;

  EarningsNotifier(this._repository, this._userId)
    : super(const AsyncLoading());

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _updateState(
    AsyncValue<(EarningsSummaryModel, List<TransactionModel>)> newState,
  ) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  Future<void> loadData() async {
    if (_isDisposed) return;

    _updateState(const AsyncLoading());
    try {
      final results = await Future.wait([
        _repository.getEarningsSummary(_userId),
        _repository.getRecentTransactions(_userId),
        _repository.getWithdrawalHistory(
          _userId,
        ), // ✅ إضافة استدعاء getWithdrawalHistory
      ]);

      // دمج المعاملات من recent transactions و withdrawal history
      final recentTransactions = results[1] as List<TransactionModel>;
      final withdrawalHistory = results[2] as List<TransactionModel>;

      // دمج القائمتين وترتيبهما حسب التاريخ
      final allTransactions = [...recentTransactions, ...withdrawalHistory];
      allTransactions.sort((a, b) => b.date.compareTo(a.date));

      if (!_isDisposed) {
        _updateState(
          AsyncData((results[0] as EarningsSummaryModel, allTransactions)),
        );
      }
    } catch (e, st) {
      if (!_isDisposed) {
        _updateState(AsyncError(e, st));
      }
    }
  }

  Future<void> withdrawToShamCash({required double amount}) async {
    if (_isDisposed) return;

    _updateState(const AsyncLoading());
    try {
      await _repository.withdrawToShamCash(userId: _userId, amount: amount);

      if (!_isDisposed) {
        await loadData();
      }
    } catch (e, st) {
      if (!_isDisposed) {
        _updateState(AsyncError(e, st));
      }
      rethrow;
    }
  }

  // ⚠️ دالة السحب القديمة (معطلة)
  Future<void> requestWithdrawal({
    required double amount,
    required String bankName,
    required String accountNumber,
  }) async {
    throw Exception(
      'This withdrawal method is temporarily disabled. Please use "Withdraw to Sham Cash" instead.',
    );
  }
}

final earningsProvider =
    StateNotifierProvider<
      EarningsNotifier,
      AsyncValue<(EarningsSummaryModel, List<TransactionModel>)>
    >((ref) {
      final repository = ref.watch(earningsRepositoryProvider);
      final supabaseClient = ref.watch(supabaseClientProvider);
      final user = supabaseClient.auth.currentUser;

      if (user == null) throw Exception('User not authenticated');

      final notifier = EarningsNotifier(repository, user.id);
      notifier.loadData();
      return notifier;
    });
