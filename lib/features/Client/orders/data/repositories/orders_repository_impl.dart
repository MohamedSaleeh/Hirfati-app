import '../../../../../core/models/order.dart';
import '../../domain/models/order_model.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_supabase_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersSupabaseDatasource _datasource;

  OrdersRepositoryImpl(this._datasource);

  @override
  Future<List<OrderModel>> getClientOrders(OrderStatus status) {
    return _datasource.getClientOrders(status);
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    return _datasource.cancelOrder(orderId);
  }

  @override
  Future<String> reorder(String oldOrderId) async {
    return _datasource.reorder(oldOrderId);
  }

    @override
  Future<void> updatePaymentStatus(
    String orderId,
    PaymentStatus status, {
    String? paymentMethod,
    String? transactionId,
  }) async {
    return _datasource.updatePaymentStatus(
      orderId,
      status,
      paymentMethod: paymentMethod,
      transactionId: transactionId,
    );
  }
}
