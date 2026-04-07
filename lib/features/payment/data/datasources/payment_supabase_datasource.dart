import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/payment.dart';

class PaymentSupabaseDatasource {
  final SupabaseClient _client;

  PaymentSupabaseDatasource(this._client);

  Future<Payment> createPayment({
    required String orderId,
    required double amount,
    required String userId,
    String? paymentMethod,
  }) async {
    final response = await _client
        .from('payments')
        .insert({
          'order_id': orderId,
          'amount': amount,
          'user_id': userId,
          'payment_method': paymentMethod,
          'status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return Payment(
      id: response['id'],
      orderId: response['order_id'],
      amount: (response['amount'] as num).toDouble(),
      status: _parseStatus(response['status']),
      paymentMethod: response['payment_method'],
      transactionId: response['transaction_id'],
      paidAt: response['paid_at'] != null
          ? DateTime.parse(response['paid_at'])
          : null,
      createdAt: DateTime.parse(response['created_at']),
    );
  }

  Future<Payment> updatePaymentStatus(
    String paymentId,
    PaymentTransactionStatus status, {
    String? transactionId,
  }) async {
    print('📝 Updating payment status:');
    print('   - paymentId: $paymentId');
    print('   - status: ${status.name}');
    print('   - transactionId: $transactionId');

    final updateData = {
      'status': _statusToString(status),
      if (transactionId != null) 'transaction_id': transactionId,
      if (status == PaymentTransactionStatus.completed)
        'paid_at': DateTime.now().toIso8601String(),
    };

    // ✅ أولاً: تحديث البيانات
    await _client.from('payments').update(updateData).eq('id', paymentId);

    // ✅ ثانياً: جلب البيانات بعد التحديث
    final response = await _client
        .from('payments')
        .select()
        .eq('id', paymentId)
        .maybeSingle();

    if (response == null) {
      print('❌ Payment not found after update: $paymentId');
      throw Exception('Payment not found');
    }

    print('✅ Payment status updated: ${response['status']}');

    return Payment(
      id: response['id'],
      orderId: response['order_id'],
      amount: (response['amount'] as num).toDouble(),
      status: _parseStatus(response['status']),
      paymentMethod: response['payment_method'],
      transactionId: response['transaction_id'],
      paidAt: response['paid_at'] != null
          ? DateTime.parse(response['paid_at'])
          : null,
      createdAt: DateTime.parse(response['created_at']),
    );
  }

  Future<Payment?> getPaymentByOrderId(String orderId) async {
    print('🔍 Getting payment by orderId: $orderId');

    final response = await _client
        .from('payments')
        .select()
        .eq('order_id', orderId)
        .maybeSingle();

    if (response == null) {
      print('⚠️ No payment found for order: $orderId');
      return null;
    }

    return Payment(
      id: response['id'],
      orderId: response['order_id'],
      amount: (response['amount'] as num).toDouble(),
      status: _parseStatus(response['status']),
      paymentMethod: response['payment_method'],
      transactionId: response['transaction_id'],
      paidAt: response['paid_at'] != null
          ? DateTime.parse(response['paid_at'])
          : null,
      createdAt: DateTime.parse(response['created_at']),
    );
  }

  Future<List<Payment>> getUserPayments(String userId) async {
    print('🔍 Getting payments for user: $userId');

    final response = await _client
        .from('payments')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (json) => Payment(
            id: json['id'],
            orderId: json['order_id'],
            amount: (json['amount'] as num).toDouble(),
            status: _parseStatus(json['status']),
            paymentMethod: json['payment_method'],
            transactionId: json['transaction_id'],
            paidAt: json['paid_at'] != null
                ? DateTime.parse(json['paid_at'])
                : null,
            createdAt: DateTime.parse(json['created_at']),
          ),
        )
        .toList();
  }

  String _statusToString(PaymentTransactionStatus status) {
    switch (status) {
      case PaymentTransactionStatus.pending:
        return 'pending';
      case PaymentTransactionStatus.processing:
        return 'processing';
      case PaymentTransactionStatus.completed:
        return 'completed';
      case PaymentTransactionStatus.failed:
        return 'failed';
      case PaymentTransactionStatus.refunded:
        return 'refunded';
    }
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
