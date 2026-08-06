import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/wallet_models.dart';

class WalletSupabaseDatasource {
  final SupabaseClient _client;

  WalletSupabaseDatasource(this._client);

  Future<WalletAccount?> getWallet(String userId) async {
    final response = await _client
        .from('wallets')
        .select('user_id, balance, created_at, updated_at')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return WalletAccount.fromJson(response);
  }

  Future<List<WalletTransaction>> getTransactions(String userId) async {
    final response = await _client
        .from('wallet_transactions')
        .select(
          'id, wallet_user_id, counterparty_user_id, payment_id, order_id, '
          'transaction_type, direction, amount, balance_before, balance_after, '
          'status, transfer_group, currency, title, description, created_at',
        )
        .eq('wallet_user_id', userId)
        .order('created_at', ascending: false);

    return _rows(response).map(WalletTransaction.fromJson).toList();
  }

  Future<List<WalletPaymentEvent>> getPaymentEvents({
    required String userId,
    required String paymentId,
  }) async {
    if (paymentId.isEmpty) return const [];

    final payment = await _client
        .from('payments')
        .select('id')
        .eq('id', paymentId)
        .or('payer_id.eq.$userId,payee_id.eq.$userId')
        .maybeSingle();

    if (payment == null) return const [];

    final response = await _client
        .from('payment_events')
        .select(
          'id, payment_id, event_type, event_data, created_at, created_by',
        )
        .eq('payment_id', paymentId)
        .order('created_at', ascending: true);

    return _rows(response).map(WalletPaymentEvent.fromJson).toList();
  }

  List<Map<String, dynamic>> _rows(Object? response) {
    if (response is! List) return const [];

    return response
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
}
