import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint('============================================');
      debugPrint('SETTLE WALLET PAYMENT START');
      debugPrint('Order ID: $orderId');
      debugPrint('Idempotency Key: $idempotencyKey');
      debugPrint('============================================');

      final params = settlementParameters(
        orderId: orderId,
        idempotencyKey: idempotencyKey,
      );

      debugPrint('RPC Name: settle_order_payment');
      debugPrint('RPC Params: $params');

      final response = await _client.rpc(
        'settle_order_payment',
        params: params,
      );

      debugPrint('');
      debugPrint('========== SETTLE RPC RESPONSE ==========');
      debugPrint('Response: $response');
      debugPrint('Response type: ${response.runtimeType}');
      debugPrint('=========================================');

      final json = _responseMap(response);

      debugPrint('Parsed JSON: $json');

      final result = PaymentSettlementResult.fromJson(json);

      debugPrint('');
      debugPrint('========== SETTLEMENT RESULT ==========');
      debugPrint('success: ${result.success}');
      debugPrint('idempotent: ${result.idempotent}');
      debugPrint('paymentId: ${result.paymentId}');
      debugPrint('orderId: ${result.orderId}');
      debugPrint('=======================================');

      // إذا كانت العملية ناجحة أو سبق تنفيذها بنفس
      // idempotency key نعتبرها ناجحة.
      if (!result.success && !result.idempotent) {
        debugPrint('Settlement returned unsuccessful result.');
        debugPrint('Raw response: $response');

        throw PaymentException(
          'payment_failed',
          'Payment settlement failed. RPC response: $response',
        );
      }

      debugPrint('SETTLE WALLET PAYMENT SUCCESS');

      return result;
    } on PostgrestException catch (error, stackTrace) {
      debugPrint('');
      debugPrint('========== SUPABASE PAYMENT ERROR ==========');
      debugPrint('Message: ${error.message}');
      debugPrint('Code: ${error.code}');
      debugPrint('Details: ${error.details}');
      debugPrint('Hint: ${error.hint}');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('============================================');

      throw PaymentException(
        error.code ?? 'supabase_payment_error',
        'Supabase error: ${error.message}'
        '${error.details != null ? ' | Details: ${error.details}' : ''}'
        '${error.hint != null ? ' | Hint: ${error.hint}' : ''}',
      );
    } on PaymentException catch (error, stackTrace) {
      debugPrint('');
      debugPrint('========== PAYMENT EXCEPTION ==========');
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('=======================================');

      rethrow;
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('========== UNKNOWN PAYMENT ERROR ==========');
      debugPrint('Type: ${error.runtimeType}');
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('===========================================');

      throw PaymentException(
        'payment_failed',
        'Unexpected payment error: $error',
      );
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
      currency: response['currency']?.toString() ?? 'USD',
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
