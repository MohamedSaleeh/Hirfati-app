import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/sham_cash_account_model.dart';
import '../../domain/models/sham_cash_transaction_model.dart';

class ShamCashSupabaseDatasource {
  final SupabaseClient _client;

  ShamCashSupabaseDatasource(this._client);

  Future<ShamCashAccountModel?> getMyAccount() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        print('❌ No authenticated user');
        return null;
      }

      print('🔍 Getting Sham Cash account for user: ${user.id}');

      final response = await _client
          .from('sham_cash_accounts')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      print('📡 Response: $response');

      if (response == null) {
        print('⚠️ No Sham Cash account found for user: ${user.id}');
        return null;
      }

      // ✅ ملاحظة: جدول sham_cash_accounts لا يحتوي على عمود 'id'
      // المفتاح الأساسي هو 'user_id'
      final userId = response['user_id'] as String?;
      final accountCode = response['account_code'] as String?;
      final balance = (response['balance'] as num?)?.toDouble() ?? 0.0;
      final isActive = response['is_active'] as bool? ?? true;
      final createdAtStr = response['created_at'] as String?;

      if (userId == null || accountCode == null) {
        print(
          '❌ Missing required fields: userId=$userId, accountCode=$accountCode',
        );
        return null;
      }

      // ✅ استخدام userId كـ id (لأنه المفتاح الأساسي)
      return ShamCashAccountModel(
        id: userId, // ✅ استخدام userId بدلاً من id
        userId: userId,
        accountCode: accountCode,
        balance: balance,
        isActive: isActive,
        createdAt: createdAtStr != null
            ? DateTime.parse(createdAtStr)
            : DateTime.now(),
      );
    } catch (e) {
      print('❌ Error in getMyAccount: $e');
      return null;
    }
  }

  Future<double> getBalance() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return 0.0;

      final response = await _client
          .from('sham_cash_accounts')
          .select('balance')
          .eq('user_id', user.id)
          .maybeSingle();

      return (response?['balance'] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      print('❌ Error in getBalance: $e');
      return 0.0;
    }
  }

  Future<List<ShamCashTransactionModel>> getMyTransactions({
    int limit = 50,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        print('❌ No authenticated user');
        return [];
      }

      print('🔍 Getting transactions for user: ${user.id}');

      final response = await _client
          .from('sham_cash_transactions')
          .select('*')
          .or('from_user_id.eq.${user.id},to_user_id.eq.${user.id}')
          .order('created_at', ascending: false)
          .limit(limit);

      print('📡 Transactions response count: ${(response as List).length}');

      if (response.isEmpty) {
        print('⚠️ No transactions found');
        return [];
      }

      final transactions = <ShamCashTransactionModel>[];
      for (var json in response) {
        try {
          final id = json['id'] as String?;
          final fromUserId = json['from_user_id'] as String?;
          final toUserId = json['to_user_id'] as String?;
          final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;
          final type = json['type'] as String? ?? 'deposit';
          final status = json['status'] as String? ?? 'success';
          final reference = json['reference'] as String? ?? '';
          final createdAtStr = json['created_at'] as String?;

          if (id == null) continue;

          transactions.add(
            ShamCashTransactionModel(
              id: id,
              fromUserId: fromUserId,
              toUserId: toUserId,
              amount: amount,
              type: _parseTransactionType(type),
              status: _parseTransactionStatus(status),
              reference: reference,
              createdAt: createdAtStr != null
                  ? DateTime.parse(createdAtStr)
                  : DateTime.now(),
              fromUserName: null,
              toUserName: null,
            ),
          );
        } catch (e) {
          print('❌ Error parsing transaction: $e');
        }
      }

      return transactions;
    } catch (e) {
      print('❌ Error in getMyTransactions: $e');
      return [];
    }
  }

  TransactionType _parseTransactionType(String type) {
    switch (type) {
      case 'deposit':
        return TransactionType.deposit;
      case 'payment':
        return TransactionType.payment;
      case 'transfer':
        return TransactionType.transfer;
      case 'withdraw':
        return TransactionType.withdraw;
      default:
        return TransactionType.deposit;
    }
  }

  TransactionStatus _parseTransactionStatus(String status) {
    switch (status) {
      case 'pending':
        return TransactionStatus.pending;
      case 'success':
        return TransactionStatus.success;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.success;
    }
  }
}
