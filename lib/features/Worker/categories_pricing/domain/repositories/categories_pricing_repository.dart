import '../models/worker_service_model.dart';
import '../models/worker_category_model.dart';

abstract class CategoriesPricingRepository {
  // جلب معرف الحرفي من user_id
  Future<String?> getWorkerId(String userId);
  
  // جلب التصنيفات الخاصة بالحرفي
  Future<List<WorkerCategoryModel>> getWorkerCategories(String userId);
  
  // جلب الخدمات الخاصة بالحرفي
  Future<List<WorkerServiceModel>> getWorkerServices(String workerId);
  
  // تحديث نطاق السعر للتصنيف
  Future<void> updateCategoryPriceRange(
    String workerId,
    String categoryId,
    double priceMin,
    double priceMax,
  );
  
  // إضافة خدمة جديدة
  Future<WorkerServiceModel> addService(
    String workerId,
    String title,
    double price,
    String? description,
    int? durationMinutes,
  );
  
  // تحديث خدمة
  Future<WorkerServiceModel> updateService(WorkerServiceModel service);
  
  // حذف خدمة
  Future<void> deleteService(String serviceId);
}