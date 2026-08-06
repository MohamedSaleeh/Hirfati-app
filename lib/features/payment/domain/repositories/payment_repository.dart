import '../models/payment.dart';

abstract class PaymentRepository {
  Future<Payment> createPayment({
    required String orderId,
    required double amount,
    required String userId,
    String? paymentMethod,
  });

  Future<Payment> updatePaymentStatus(
    String paymentId,
    PaymentTransactionStatus status, {
    String? transactionId,
  });

  Future<Payment?> getPaymentByOrderId(String orderId);
  Future<List<Payment>> getUserPayments(String userId);

  Future<PaymentSettlementResult> settleOrderPayment({
    required String orderId,
    required String paymentMethod,
    required String idempotencyKey,
    String? providerTransactionId,
  });

  Future<bool> processCashPayment(String orderId, double amount);
  Future<bool> processCardPayment(
    String orderId,
    double amount,
    Map<String, dynamic> cardDetails,
  );
  Future<bool> processWalletPayment(String orderId, double amount);
}
