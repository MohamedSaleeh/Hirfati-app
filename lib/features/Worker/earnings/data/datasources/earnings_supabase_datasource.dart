import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utils/app_logger.dart';
import '../../domain/models/earnings_summary_model.dart';
import '../../domain/models/transaction_model.dart';

class EarningsSupabaseDatasource {
  final SupabaseClient _client;

  EarningsSupabaseDatasource(this._client);

  Future<String?> _getWorkerId(String userId) async {
    try {
      final response = await _client
          .from('workers')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      return response?['id'] as String?;
    } catch (error, stackTrace) {
      AppLogger.error(
        error,
        stackTrace: stackTrace,
        message: 'Unable to load worker id for earnings',
      );
      return null;
    }
  }

  Future<double> getAvailableBalance(String userId) async {
    try {
      final response = await _client
          .from('wallets')
          .select('balance')
          .eq('user_id', userId)
          .maybeSingle();

      return (response?['balance'] as num?)?.toDouble() ?? 0;
    } catch (error, stackTrace) {
      AppLogger.error(
        error,
        stackTrace: stackTrace,
        message: 'Unable to load available balance',
      );
      return 0;
    }
  }

  Future<void> updateAvailableBalance(String userId, double newBalance) async {
    throw UnsupportedError(
      'Wallet balances must be updated by protected server functions.',
    );
  }

  Future<EarningsSummaryModel> getEarningsSummary(String userId) async {
    final workerId = await _getWorkerId(userId);
    if (workerId == null) {
      return const EarningsSummaryModel(
        availableBalance: 0,
        thisWeekEarnings: 0,
        lastWeekEarnings: 0,
        weeklyChangePercent: 0,
        totalOrders: 0,
        completedOrders: 0,
      );
    }

    final balanceFuture = getAvailableBalance(userId);
    final ledgerCreditsFuture = _getLedgerCredits(userId);
    final totalOrdersFuture = _countOrders(workerId);
    final completedOrdersFuture = _countCompletedPaidOrders(workerId);

    final balance = await balanceFuture;
    final ledgerCredits = await ledgerCreditsFuture;
    final credits = ledgerCredits.isNotEmpty
        ? ledgerCredits
        : await _getPaidOrderCredits(workerId);

    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - now.weekday + 1,
    );
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));

    var thisWeekEarnings = 0.0;
    var lastWeekEarnings = 0.0;

    for (final credit in credits) {
      if (credit.date.isAfter(startOfWeek)) {
        thisWeekEarnings += credit.amount;
      } else if (credit.date.isAfter(startOfLastWeek) &&
          credit.date.isBefore(startOfWeek)) {
        lastWeekEarnings += credit.amount;
      }
    }

    final weeklyChangePercent = lastWeekEarnings > 0
        ? ((thisWeekEarnings - lastWeekEarnings) / lastWeekEarnings) * 100
        : 0.0;

    return EarningsSummaryModel(
      availableBalance: balance,
      thisWeekEarnings: thisWeekEarnings,
      lastWeekEarnings: lastWeekEarnings,
      weeklyChangePercent: weeklyChangePercent,
      totalOrders: await totalOrdersFuture,
      completedOrders: await completedOrdersFuture,
    );
  }

  Future<List<TransactionModel>> getRecentTransactions(
    String userId, {
    int limit = 10,
  }) async {
    final ledgerTransactions = await _getLedgerTransactions(userId, limit);
    if (ledgerTransactions.isNotEmpty) {
      return ledgerTransactions;
    }

    final workerId = await _getWorkerId(userId);
    if (workerId == null) return [];

    final orders = await _client
        .from('orders')
        .select(
          'id, price, paid_at, created_at, status, service_id, services(title)',
        )
        .eq('worker_id', workerId)
        .eq('status', 'completed')
        .eq('payment_status', 'paid')
        .order('paid_at', ascending: false, nullsFirst: false)
        .limit(limit);

    final transactions = <TransactionModel>[];

    for (final order in orders) {
      final service = order['services'] as Map<String, dynamic>? ?? {};
      final date =
          _parseDate(order['paid_at']) ?? _parseDate(order['created_at']);
      if (date == null) continue;

      transactions.add(
        TransactionModel(
          id: order['id'].toString(),
          title: service['title']?.toString() ?? 'Service Completed',
          amount: (order['price'] as num?)?.toDouble() ?? 0,
          date: date,
          type: TransactionType.earning,
          status: TransactionStatus.completed,
          orderId: order['id'].toString(),
        ),
      );
    }

    final withdrawals = await getWithdrawalHistory(userId);
    transactions.addAll(withdrawals);
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions.take(limit).toList();
  }

  Future<void> requestWithdrawal({
    required String userId,
    required double amount,
    required String bankName,
    required String accountNumber,
  }) async {
    throw UnsupportedError('Withdrawal is currently unavailable.');
  }

  Future<List<TransactionModel>> getWithdrawalHistory(String userId) async {
    try {
      final workerId = await _getWorkerId(userId);
      if (workerId == null) return [];

      final withdrawals = await _client
          .from('withdrawals')
          .select('id, amount, created_at, status, bank_name')
          .eq('worker_id', workerId)
          .order('created_at', ascending: false);

      return withdrawals.map((w) {
        final bankName = w['bank_name']?.toString().trim();
        return TransactionModel(
          id: w['id'].toString(),
          title: bankName == null || bankName.isEmpty
              ? 'Withdrawal'
              : 'Withdraw to $bankName',
          amount: -((w['amount'] as num?)?.toDouble() ?? 0),
          date: _parseDate(w['created_at']) ?? DateTime.now(),
          type: TransactionType.withdrawal,
          status: _parseStatus(w['status'] as String?),
        );
      }).toList();
    } catch (error, stackTrace) {
      AppLogger.error(
        error,
        stackTrace: stackTrace,
        message: 'Unable to load withdrawal history',
      );
      return [];
    }
  }

  Future<List<_EarningCredit>> _getLedgerCredits(String userId) async {
    try {
      final rows = await _client
          .from('wallet_transactions')
          .select('id, amount, created_at, order_id')
          .eq('wallet_user_id', userId)
          .eq('direction', 'credit')
          .eq('status', 'completed')
          .order('created_at', ascending: false);

      return rows
          .map<_EarningCredit?>((row) {
            final date = _parseDate(row['created_at']);
            if (date == null) return null;
            return _EarningCredit(
              amount: (row['amount'] as num?)?.toDouble() ?? 0,
              date: date,
              orderId: row['order_id']?.toString(),
            );
          })
          .whereType<_EarningCredit>()
          .toList();
    } catch (error, stackTrace) {
      AppLogger.error(
        error,
        stackTrace: stackTrace,
        message: 'Unable to load ledger credits',
      );
      return const [];
    }
  }

  Future<List<TransactionModel>> _getLedgerTransactions(
    String userId,
    int limit,
  ) async {
    try {
      final rows = await _client
          .from('wallet_transactions')
          .select(
            'id, direction, transaction_type, amount, status, order_id, '
            'withdrawal_id, title, created_at',
          )
          .eq('wallet_user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return rows
          .map<TransactionModel?>((row) {
            final date = _parseDate(row['created_at']);
            if (date == null) return null;

            final direction = row['direction']?.toString() ?? 'credit';
            final type = row['transaction_type']?.toString() ?? '';
            final isWithdrawal =
                type.toLowerCase().contains('withdrawal') ||
                row['withdrawal_id'] != null;
            final amount = (row['amount'] as num?)?.toDouble() ?? 0;
            final signedAmount = direction == 'debit' ? -amount : amount;
            final id = row['withdrawal_id']?.toString() ?? row['id'].toString();

            return TransactionModel(
              id: id,
              title: row['title']?.toString() ?? _formatLedgerTitle(type),
              amount: signedAmount,
              date: date,
              type: isWithdrawal
                  ? TransactionType.withdrawal
                  : TransactionType.earning,
              status: _parseStatus(row['status'] as String?),
              orderId: row['order_id']?.toString(),
            );
          })
          .whereType<TransactionModel>()
          .toList();
    } catch (error, stackTrace) {
      AppLogger.error(
        error,
        stackTrace: stackTrace,
        message: 'Unable to load ledger transactions',
      );
      return const [];
    }
  }

  Future<List<_EarningCredit>> _getPaidOrderCredits(String workerId) async {
    final paidOrders = await _client
        .from('orders')
        .select('id, price, paid_at, created_at')
        .eq('worker_id', workerId)
        .eq('status', 'completed')
        .eq('payment_status', 'paid');

    return paidOrders
        .map<_EarningCredit?>((order) {
          final date =
              _parseDate(order['paid_at']) ?? _parseDate(order['created_at']);
          if (date == null) return null;
          return _EarningCredit(
            amount: (order['price'] as num?)?.toDouble() ?? 0,
            date: date,
            orderId: order['id']?.toString(),
          );
        })
        .whereType<_EarningCredit>()
        .toList();
  }

  Future<int> _countOrders(String workerId) async {
    final orders = await _client
        .from('orders')
        .select('id')
        .eq('worker_id', workerId);
    return orders.length;
  }

  Future<int> _countCompletedPaidOrders(String workerId) async {
    final orders = await _client
        .from('orders')
        .select('id')
        .eq('worker_id', workerId)
        .eq('status', 'completed')
        .eq('payment_status', 'paid');
    return orders.length;
  }

  TransactionStatus _parseStatus(String? status) {
    switch (status) {
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  String _formatLedgerTitle(String value) {
    final words = value
        .split(RegExp(r'[_\s-]+'))
        .where((word) => word.isNotEmpty)
        .map((word) {
          if (word.length == 1) return word.toUpperCase();
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');

    return words.isEmpty ? 'Wallet Transaction' : words;
  }
}

class _EarningCredit {
  final double amount;
  final DateTime date;
  final String? orderId;

  const _EarningCredit({
    required this.amount,
    required this.date,
    this.orderId,
  });
}
