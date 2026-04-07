import '../../domain/models/incoming_order_model.dart';
import '../../domain/repositories/incoming_orders_repository.dart';
import '../datasources/incoming_orders_supabase_datasource.dart';

class IncomingOrdersRepositoryImpl implements IncomingOrdersRepository {
  final IncomingOrdersSupabaseDatasource _datasource;

  IncomingOrdersRepositoryImpl(this._datasource);

  @override
  Future<List<IncomingOrderModel>> getIncomingOrders(String userId) async {
    return await _datasource.getIncomingOrders(userId);
  }

  @override
  Future<void> acceptOrder(String orderId) async {
    await _datasource.acceptOrder(orderId);
  }

  @override
  Future<void> rejectOrder(String orderId) async {
    await _datasource.rejectOrder(orderId);
  }
}
