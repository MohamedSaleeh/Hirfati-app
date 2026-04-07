import '../../domain/models/work_category_model.dart';
import '../../domain/models/work_item_model.dart';
import '../../domain/repositories/work_gallery_repository.dart';
import '../datasources/work_gallery_supabase_datasource.dart';

class WorkGalleryRepositoryImpl implements WorkGalleryRepository {
  final WorkGallerySupabaseDatasource _datasource;

  WorkGalleryRepositoryImpl(this._datasource);

  @override
  Future<String?> getWorkerId(String userId) async {
    return await _datasource.getWorkerId(userId);
  }

  @override
  Future<List<WorkItemModel>> getWorkItems(String userId) async {
    return await _datasource.getWorkItems(userId);
  }

  @override
  Future<List<WorkCategoryModel>> getCategories() async {
    return await _datasource.getCategories();
  }

  @override
  Future<WorkItemModel> addWorkItem({
    required String workerId,
    required String title,
    required String description,
    required List<String> imageUrls,
    required String category,
    required String complexity,
  }) async {
    return await _datasource.addWorkItem(
      workerId: workerId,
      title: title,
      description: description,
      imageUrls: imageUrls,
      category: category,
      complexity: complexity,
    );
  }

  @override
  Future<void> deleteWorkItem(String workId) async {
    await _datasource.deleteWorkItem(workId);
  }

  @override
  Future<void> incrementViews(String workId) async {
    await _datasource.incrementViews(workId);
  }
}