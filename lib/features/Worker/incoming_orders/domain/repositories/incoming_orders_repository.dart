import '../models/incoming_order_model.dart';

abstract class IncomingOrdersRepository {
  Future<List<IncomingOrderModel>> getIncomingOrders(String workerId);
  Future<void> acceptOrder(String orderId);
  Future<void> rejectOrder(String orderId);
}