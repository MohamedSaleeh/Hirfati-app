import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Home_client/domain_models/category_model.dart';
import '../../domain/models/create_order_model.dart';
import '../../domain/models/service_model.dart';
import '../../domain/repositories/create_order_repository.dart';
import '../datasources/create_order_supabase_datasource.dart';

final createOrderRepositoryProvider = Provider<CreateOrderRepository>((ref) {
  return CreateOrderRepositoryImpl(
    CreateOrderSupabaseDatasource(Supabase.instance.client),
  );
});

class CreateOrderRepositoryImpl implements CreateOrderRepository {
  final CreateOrderSupabaseDatasource _datasource;

  CreateOrderRepositoryImpl(this._datasource);

  @override
  Future<List<CategoryModel>> getCategories() => _datasource.getCategories();

  @override
  Future<List<ServiceModel>> getWorkerServices(String workerId) =>
      _datasource.getWorkerServices(workerId);

  @override
  Future<void> createOrder(CreateOrderModel order) =>
      _datasource.createOrder(order);

  @override
  Future<String> uploadPhoto(String localPath, String orderId, int index) =>
      _datasource.uploadPhoto(localPath, orderId, index);

  @override
  Future<({String? address, double? latitude, double? longitude})>
  getDefaultAddress() => _datasource.getDefaultAddress();
}
