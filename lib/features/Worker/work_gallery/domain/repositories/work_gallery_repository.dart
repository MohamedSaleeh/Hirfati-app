import '../models/work_item_model.dart';
import '../models/work_category_model.dart';

abstract class WorkGalleryRepository {
  Future<String?> getWorkerId(String userId);
  Future<List<WorkItemModel>> getWorkItems(String workerId);
  Future<List<WorkCategoryModel>> getCategories();
  Future<WorkItemModel> addWorkItem({
    required String workerId,
    required String title,
    required String description,
    required List<String> imageUrls,
    required String category,
    required String complexity,
  });
  Future<void> deleteWorkItem(String workId);
  Future<void> incrementViews(String workId);
}