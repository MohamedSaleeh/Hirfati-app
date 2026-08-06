import '../../domain/models/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_supabase_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentSupabaseDatasource _datasource;

  PaymentRepositoryImpl(this._datasource);

  @override
  Future<Payment?> getPaymentByOrderId(String orderId) {
    return _datasource.getPaymentByOrderId(orderId);
  }

  @override
  Future<PaymentSettlementResult> processWalletPayment(
    String orderId,
    String idempotencyKey,
  ) {
    return _datasource.settleWalletPayment(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
    );
  }
}
