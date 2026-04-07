import '../../../Home_client/domain_models/category_model.dart';
import '../models/create_order_model.dart';
import '../models/service_model.dart';

abstract class CreateOrderRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ServiceModel>> getWorkerServices(String workerId);
  Future<String> uploadPhoto(String localPath, String orderId, int index);
  Future<void> createOrder(CreateOrderModel order);
  Future<({String? address, double? latitude, double? longitude})>
  getDefaultAddress();
}
