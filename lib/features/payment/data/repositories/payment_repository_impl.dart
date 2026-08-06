import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/payment_repository.dart';
import '../../domain/models/payment.dart';
import '../datasources/payment_supabase_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentSupabaseDatasource _datasource;

  PaymentRepositoryImpl(this._datasource);

  @override
  Future<Payment> createPayment({
    required String orderId,
    required double amount,
    required String userId,
    String? paymentMethod,
  }) async {
    return await _datasource.createPayment(
      orderId: orderId,
      amount: amount,
      userId: userId,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<Payment> updatePaymentStatus(
    String paymentId,
    PaymentTransactionStatus status, {
    String? transactionId,
  }) async {
    return await _datasource.updatePaymentStatus(
      paymentId,
      status,
      transactionId: transactionId,
    );
  }

  @override
  Future<Payment?> getPaymentByOrderId(String orderId) async {
    return await _datasource.getPaymentByOrderId(orderId);
  }

  @override
  Future<List<Payment>> getUserPayments(String userId) async {
    return await _datasource.getUserPayments(userId);
  }

  @override
  Future<PaymentSettlementResult> settleOrderPayment({
    required String orderId,
    required String paymentMethod,
    required String idempotencyKey,
    String? providerTransactionId,
  }) async {
    return _datasource.settleOrderPayment(
      orderId: orderId,
      paymentMethod: paymentMethod,
      idempotencyKey: idempotencyKey,
      providerTransactionId: providerTransactionId,
    );
  }

  @override
  Future<bool> processCashPayment(String orderId, double amount) async {
    return false;
  }

  @override
  Future<bool> processCardPayment(
    String orderId,
    double amount,
    Map<String, dynamic> cardDetails,
  ) async {
    return false;
  }

  @override
  Future<bool> processWalletPayment(String orderId, double amount) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('unauthenticated');
    }

    final result = await settleOrderPayment(
      orderId: orderId,
      paymentMethod: 'wallet',
      idempotencyKey: 'order:$orderId:wallet:user:$userId',
    );

    return result.success;
  }
}
