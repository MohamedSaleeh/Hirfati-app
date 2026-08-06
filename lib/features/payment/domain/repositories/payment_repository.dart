import '../models/payment.dart';

abstract class PaymentRepository {
  Future<Payment?> getPaymentByOrderId(String orderId);

  Future<PaymentSettlementResult> processWalletPayment(
    String orderId,
    String idempotencyKey,
  );
}
