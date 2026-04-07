
import '../../domain/models/worker_category_model.dart';
import '../../domain/models/worker_service_model.dart';
import '../../domain/repositories/categories_pricing_repository.dart';
import '../datasources/categories_pricing_supabase_datasource.dart';

class CategoriesPricingRepositoryImpl implements CategoriesPricingRepository {
  final CategoriesPricingSupabaseDatasource _datasource;

  CategoriesPricingRepositoryImpl(this._datasource);

  @override
  Future<String?> getWorkerId(String userId) async {
    return await _datasource.getWorkerId(userId);
  }

  @override
  Future<List<WorkerCategoryModel>> getWorkerCategories(String userId) async {
    return await _datasource.getWorkerCategories(userId);
  }

  @override
  Future<List<WorkerServiceModel>> getWorkerServices(String workerId) async {
    return await _datasource.getWorkerServices(workerId);
  }

  @override
  Future<void> updateCategoryPriceRange(
    String workerId,
    String categoryId,
    double priceMin,
    double priceMax,
  ) async {
    await _datasource.updateCategoryPriceRange(workerId, categoryId, priceMin, priceMax);
  }

  @override
  Future<WorkerServiceModel> addService(
    String workerId,
    String title,
    double price,
    String? description,
    int? durationMinutes,
  ) async {
    return await _datasource.addService(workerId, title, price, description, durationMinutes);
  }

  @override
  Future<WorkerServiceModel> updateService(WorkerServiceModel service) async {
    return await _datasource.updateService(service);
  }

  @override
  Future<void> deleteService(String serviceId) async {
    await _datasource.deleteService(serviceId);
  }
}