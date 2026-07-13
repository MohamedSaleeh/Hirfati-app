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

  Future<List<WalletPayment>> getPayments(String userId) async {
    final response = await _client
        .from('payments')
        .select(
          'id, order_id, amount, status, payment_method, transaction_id, '
          'created_at, paid_at, user_id, reference_number, fee, metadata, '
          'idempotency_key, updated_at, provider',
        )
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return _rows(response).map(WalletPayment.fromJson).toList();
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
        .eq('user_id', userId)
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
