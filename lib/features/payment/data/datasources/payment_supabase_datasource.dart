import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/payment.dart';

class PaymentSupabaseDatasource {
  final SupabaseClient _client;

  PaymentSupabaseDatasource(this._client);

  Future<PaymentSettlementResult> settleOrderPayment({
    required String orderId,
    required String paymentMethod,
    required String idempotencyKey,
    String? providerTransactionId,
  }) async {
    final params = <String, dynamic>{
      'p_order_id': orderId,
      'p_payment_method': paymentMethod,
      'p_idempotency_key': idempotencyKey,
    };
    if (providerTransactionId != null) {
      params['p_provider_transaction_id'] = providerTransactionId;
    }

    final response = await _client.rpc('settle_order_payment', params: params);

    return PaymentSettlementResult.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  Future<Payment> createPayment({
    required String orderId,
    required double amount,
    required String userId,
    String? paymentMethod,
  }) async {
    throw UnsupportedError(
      'Payment records must be created by the settle_order_payment RPC.',
    );
  }

  Future<Payment> updatePaymentStatus(
    String paymentId,
    PaymentTransactionStatus status, {
    String? transactionId,
  }) async {
    throw UnsupportedError(
      'Payment status changes must use the settle_order_payment RPC.',
    );
  }

  Future<Payment?> getPaymentByOrderId(String orderId) async {
    final response = await _client
        .from('payments')
        .select()
        .eq('order_id', orderId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Payment(
      id: response['id']?.toString() ?? '',
      orderId: response['order_id']?.toString() ?? '',
      amount: _parseAmount(response['amount']),
      status: _parseStatus(response['status']?.toString() ?? ''),
      paymentMethod: response['payment_method']?.toString(),
      transactionId: response['transaction_id']?.toString(),
      paidAt: response['paid_at'] != null
          ? DateTime.parse(response['paid_at'].toString())
          : null,
      createdAt: DateTime.parse(response['created_at'].toString()),
    );
  }

  Future<List<Payment>> getUserPayments(String userId) async {
    final response = await _client
        .from('payments')
        .select()
        .or('payer_id.eq.$userId,payee_id.eq.$userId')
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (json) => Payment(
            id: json['id']?.toString() ?? '',
            orderId: json['order_id']?.toString() ?? '',
            amount: _parseAmount(json['amount']),
            status: _parseStatus(json['status']?.toString() ?? ''),
            paymentMethod: json['payment_method']?.toString(),
            transactionId: json['transaction_id']?.toString(),
            paidAt: json['paid_at'] != null
                ? DateTime.parse(json['paid_at'].toString())
                : null,
            createdAt: DateTime.parse(json['created_at'].toString()),
          ),
        )
        .toList();
  }

  double _parseAmount(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  PaymentTransactionStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return PaymentTransactionStatus.pending;
      case 'processing':
        return PaymentTransactionStatus.processing;
      case 'completed':
        return PaymentTransactionStatus.completed;
      case 'failed':
        return PaymentTransactionStatus.failed;
      case 'refunded':
        return PaymentTransactionStatus.refunded;
      default:
        return PaymentTransactionStatus.pending;
    }
  }
}
