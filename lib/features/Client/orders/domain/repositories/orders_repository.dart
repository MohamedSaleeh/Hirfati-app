import '../../../../../core/models/order.dart';
import '../models/order_model.dart';

abstract class OrdersRepository {
  /// Fetches orders for the currently authenticated client by specific status
  Future<List<OrderModel>> getClientOrders(OrderStatus status);
  Future<void> cancelOrder(String orderId);
  Future<String> reorder(String oldOrderId);
    Future<void> updatePaymentStatus(
    String orderId,
    PaymentStatus status, {
    String? paymentMethod,
    String? transactionId,
  });
}
