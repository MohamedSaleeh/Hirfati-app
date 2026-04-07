import '../../domain/models/category_model.dart';
import '../../domain/models/worker_profile_model.dart';

abstract class WorkerProfileRepository {
  Future<List<CategoryModel>> getCategories();
  Future<void> submitProfile(WorkerProfileModel profile);
}
