import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/payment.dart';

class PaymentSupabaseDatasource {
  final SupabaseClient _client;

  PaymentSupabaseDatasource(this._client);

  static Map<String, dynamic> settlementParameters({
    required String orderId,
    required String idempotencyKey,
  }) {
    return {
      'p_order_id': orderId,
      'p_payment_method': 'wallet',
      'p_idempotency_key': idempotencyKey,
      'p_provider_transaction_id': null,
      'p_provider': 'wallet',
    };
  }

  Future<PaymentSettlementResult> settleWalletPayment({
    required String orderId,
    required String idempotencyKey,
  }) async {
    try {
      final response = await _client.rpc(
        'settle_order_payment',
        params: settlementParameters(
          orderId: orderId,
          idempotencyKey: idempotencyKey,
        ),
      );
      final json = _responseMap(response);
      final result = PaymentSettlementResult.fromJson(json);
      if (!result.success) {
        throw const PaymentException('payment_failed', 'Payment failed');
      }
      return result;
    } on PostgrestException catch (error) {
      throw mapPaymentError(error);
    } on PaymentException {
      rethrow;
    } catch (_) {
      throw const PaymentException('payment_failed', 'Payment failed');
    }
  }

  Future<Payment?> getPaymentByOrderId(String orderId) async {
    final response = await _client
        .from('payments')
        .select()
        .eq('order_id', orderId)
        .maybeSingle();
    if (response == null) return null;

    return Payment(
      id: response['id'].toString(),
      orderId: response['order_id'].toString(),
      amount: (response['amount'] as num).toDouble(),
      status: _parseStatus(response['status']?.toString()),
      paymentMethod: response['payment_method']?.toString(),
      transactionId: response['transaction_id']?.toString(),
      paidAt: DateTime.tryParse(response['paid_at']?.toString() ?? ''),
      createdAt:
          DateTime.tryParse(response['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static PaymentException mapPaymentError(Object error) {
    final raw = error is PostgrestException
        ? '${error.code} ${error.message} ${error.details}'
        : error.toString();
    const messages = {
      'insufficient_wallet_balance': 'Insufficient wallet balance',
      'already_paid': 'This order has already been paid',
      'invalid_order_state': 'This order cannot be paid in its current state',
      'idempotency_conflict':
          'This payment attempt conflicts with another request',
      'forbidden': 'You are not allowed to pay this order',
      'unauthenticated': 'Please sign in to continue',
      'worker_wallet_not_found': 'The worker wallet is not available',
    };
    for (final entry in messages.entries) {
      if (raw.contains(entry.key)) {
        return PaymentException(entry.key, entry.value);
      }
    }
    return const PaymentException('payment_failed', 'Payment failed');
  }

  Map<String, dynamic> _responseMap(Object? response) {
    if (response is Map) return Map<String, dynamic>.from(response);
    if (response is List && response.isNotEmpty && response.first is Map) {
      return Map<String, dynamic>.from(response.first as Map);
    }
    return const {};
  }

  PaymentTransactionStatus _parseStatus(String? status) {
    return switch (status) {
      'processing' => PaymentTransactionStatus.processing,
      'completed' => PaymentTransactionStatus.completed,
      'failed' => PaymentTransactionStatus.failed,
      'refunded' => PaymentTransactionStatus.refunded,
      _ => PaymentTransactionStatus.pending,
    };
  }
}
