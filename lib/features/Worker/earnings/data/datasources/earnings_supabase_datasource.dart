import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/earnings_summary_model.dart';
import '../../domain/models/transaction_model.dart';

class EarningsSupabaseDatasource {
  final SupabaseClient _client;

  EarningsSupabaseDatasource(this._client);

  Future<String?> _getWorkerId(String userId) async {
    print('🔍 _getWorkerId called for userId: $userId');

    try {
      final response = await _client
          .from('workers')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      final workerId = response?['id'] as String?;
      print('✅ Worker ID found: $workerId');
      return workerId;
    } catch (e) {
      print('❌ Error getting worker ID: $e');
      return null;
    }
  }

  Future<double> getAvailableBalance(String userId) async {
    print('💰 getAvailableBalance called for userId: $userId');

    try {
      final response = await _client
          .from('wallets')
          .select('balance')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        print('⚠️ No wallet found, creating new wallet');
        await _client.from('wallets').insert({
          'user_id': userId,
          'balance': 0,
          'created_at': DateTime.now().toIso8601String(),
        });
        return 0;
      }

      final balance = (response['balance'] as num?)?.toDouble() ?? 0;
      print('✅ Current balance: $balance');
      return balance;
    } catch (e) {
      print('❌ Error in getAvailableBalance: $e');
      return 0;
    }
  }

  Future<void> updateAvailableBalance(String userId, double newBalance) async {
    print(
      '💰 updateAvailableBalance called for userId: $userId, newBalance: $newBalance',
    );

    try {
      final existing = await _client
          .from('wallets')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (existing == null) {
        await _client.from('wallets').insert({
          'user_id': userId,
          'balance': newBalance,
          'created_at': DateTime.now().toIso8601String(),
        });
        print('✅ New wallet created: $newBalance');
      } else {
        await _client
            .from('wallets')
            .update({
              'balance': newBalance,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId);
        print('✅ Balance updated to: $newBalance');
      }
    } catch (e) {
      print('❌ Error updating balance: $e');
      rethrow;
    }
  }

  // ✅ دالة جديدة: السحب إلى حساب شام كاش
  Future<void> withdrawToShamCash({
    required String userId,
    required double amount,
  }) async {
    print('🏧 withdrawToShamCash called for userId: $userId, amount: $amount');

    try {
      // ✅ استخدام RPC لضمان الذرية وتجاوز RLS
      final response = await _client.rpc(
        'withdraw_to_sham_cash',
        params: {'p_user_id': userId, 'p_amount': amount},
      );

      print('✅ RPC response: $response');

      // التحقق من النجاح
      final isSuccess = response['success'] as bool? ?? false;
      if (!isSuccess) {
        throw Exception(response['error'] as String? ?? 'Withdrawal failed');
      }

      final newWalletBalance =
          (response['new_wallet_balance'] as num?)?.toDouble() ?? 0;
      final newShamCashBalance =
          (response['new_sham_cash_balance'] as num?)?.toDouble() ?? 0;

      print('✅ Withdrawal completed successfully');
      print('   New wallet balance: $newWalletBalance');
      print('   New Sham Cash balance: $newShamCashBalance');
    } catch (e) {
      print('❌ Error in withdrawToShamCash: $e');
      rethrow;
    }
  }

  // ✅ دالة للحصول على رصيد شام كاش
  Future<double> getShamCashBalance(String userId) async {
    try {
      final response = await _client
          .from('sham_cash_accounts')
          .select('balance')
          .eq('user_id', userId)
          .maybeSingle();

      return (response?['balance'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      print('❌ Error getting Sham Cash balance: $e');
      return 0;
    }
  }

  Future<double> _calculateTotalEarnings(String workerId) async {
    print('📊 _calculateTotalEarnings for workerId: $workerId');

    try {
      final completedOrders = await _client
          .from('orders')
          .select('price')
          .eq('worker_id', workerId)
          .eq('status', 'completed')
          .eq('payment_status', 'paid');

      double total = 0;
      for (final order in completedOrders) {
        total += (order['price'] as num?)?.toDouble() ?? 0;
      }

      print(
        '✅ Total earnings calculated: $total from ${completedOrders.length} paid orders',
      );
      return total;
    } catch (e) {
      print('❌ Error calculating total earnings: $e');
      return 0;
    }
  }

  Future<EarningsSummaryModel> getEarningsSummary(String userId) async {
    print('📈 getEarningsSummary called for userId: $userId');

    try {
      final workerId = await _getWorkerId(userId);
      if (workerId == null) {
        print('⚠️ Worker not found, returning empty summary');
        return EarningsSummaryModel(
          availableBalance: 0,
          thisWeekEarnings: 0,
          lastWeekEarnings: 0,
          weeklyChangePercent: 0,
          totalOrders: 0,
          completedOrders: 0,
        );
      }

      final balance = await getAvailableBalance(userId);

      final paidOrders = await _client
          .from('orders')
          .select('price, created_at, payment_status')
          .eq('worker_id', workerId)
          .eq('status', 'completed')
          .eq('payment_status', 'paid');

      final now = DateTime.now();
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day - now.weekday + 1,
      );
      final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));

      double thisWeekEarnings = 0;
      double lastWeekEarnings = 0;

      for (final order in paidOrders) {
        final price = (order['price'] as num?)?.toDouble() ?? 0;
        final createdAt = DateTime.parse(order['created_at']);

        if (createdAt.isAfter(startOfWeek)) {
          thisWeekEarnings += price;
        } else if (createdAt.isAfter(startOfLastWeek) &&
            createdAt.isBefore(startOfWeek)) {
          lastWeekEarnings += price;
        }
      }

      final weeklyChangePercent = lastWeekEarnings > 0
          ? ((thisWeekEarnings - lastWeekEarnings) / lastWeekEarnings) * 100
          : 0.0;

      final allOrders = await _client
          .from('orders')
          .select('status')
          .eq('worker_id', workerId);

      final allCompletedOrders = await _client
          .from('orders')
          .select('id')
          .eq('worker_id', workerId)
          .eq('status', 'completed')
          .eq('payment_status', 'paid');

      return EarningsSummaryModel(
        availableBalance: balance,
        thisWeekEarnings: thisWeekEarnings,
        lastWeekEarnings: lastWeekEarnings,
        weeklyChangePercent: weeklyChangePercent,
        totalOrders: allOrders.length,
        completedOrders: allCompletedOrders.length,
      );
    } catch (e, stack) {
      print('❌ Error in getEarningsSummary: $e');
      print('📚 Stack trace: $stack');
      rethrow;
    }
  }

  Future<List<TransactionModel>> getRecentTransactions(
    String userId, {
    int limit = 10,
  }) async {
    print('📜 getRecentTransactions called for userId: $userId, limit: $limit');

    try {
      final workerId = await _getWorkerId(userId);
      if (workerId == null) return [];

      final orders = await _client
          .from('orders')
          .select('id, price, created_at, status, service_id, services(title)')
          .eq('worker_id', workerId)
          .eq('status', 'completed')
          .eq('payment_status', 'paid')
          .order('created_at', ascending: false)
          .limit(limit);

      final transactions = <TransactionModel>[];

      for (final order in orders) {
        final service = order['services'] as Map<String, dynamic>? ?? {};
        transactions.add(
          TransactionModel(
            id: order['id'],
            title: service['title']?.toString() ?? 'Service Completed',
            amount: (order['price'] as num?)?.toDouble() ?? 0,
            date: DateTime.parse(order['created_at']),
            type: TransactionType.earning,
            status: TransactionStatus.completed,
            orderId: order['id'],
          ),
        );
      }

      // ✅ جلب عمليات السحب إلى شام كاش
      final withdrawals = await _client
          .from('withdrawals')
          .select('id, amount, created_at, status, bank_name')
          .eq('worker_id', workerId)
          .order('created_at', ascending: false)
          .limit(limit - transactions.length);

      for (final withdrawal in withdrawals) {
        transactions.add(
          TransactionModel(
            id: withdrawal['id'],
            title: withdrawal['bank_name'] == 'Sham Cash'
                ? 'Withdraw to Sham Cash'
                : 'Withdraw to ${withdrawal['bank_name']}',
            amount: -(withdrawal['amount'] as num).toDouble(),
            date: DateTime.parse(withdrawal['created_at']),
            type: TransactionType.withdrawal,
            status: _parseStatus(withdrawal['status']),
          ),
        );
      }

      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions.take(limit).toList();
    } catch (e) {
      print('❌ Error in getRecentTransactions: $e');
      return [];
    }
  }

  // ✅ تعديل دالة الطلب القديمة (لتعطيلها مؤقتاً)
  Future<void> requestWithdrawal({
    required String userId,
    required double amount,
    required String bankName,
    required String accountNumber,
  }) async {
    throw Exception(
      'This withdrawal method is temporarily disabled. Please use "Withdraw to Sham Cash" instead.',
    );
  }

  Future<List<TransactionModel>> getWithdrawalHistory(String userId) async {
    print('📜 getWithdrawalHistory called for userId: $userId');

    try {
      final workerId = await _getWorkerId(userId);
      if (workerId == null) return [];

      final withdrawals = await _client
          .from('withdrawals')
          .select('id, amount, created_at, status, bank_name')
          .eq('worker_id', workerId)
          .order('created_at', ascending: false);

      return withdrawals
          .map(
            (w) => TransactionModel(
              id: w['id'],
              title: w['bank_name'] == 'Sham Cash'
                  ? 'Withdraw to Sham Cash'
                  : 'Withdraw to ${w['bank_name']}',
              amount: -(w['amount'] as num).toDouble(),
              date: DateTime.parse(w['created_at']),
              type: TransactionType.withdrawal,
              status: _parseStatus(w['status']),
            ),
          )
          .toList();
    } catch (e) {
      print('❌ Error in getWithdrawalHistory: $e');
      return [];
    }
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
}
