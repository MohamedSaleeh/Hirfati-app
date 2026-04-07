import '../../domain_models/category_model.dart';
import '../../domain_models/craftsman_model.dart';

abstract class HomeClientRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<CraftsmanModel>> getRecommendedCraftsmen();
  Future<List<CraftsmanModel>> searchCraftsmen(String query);
  Future<List<CraftsmanModel>> getNearbyCraftsmen();
  Future<String?> getUserCity();
}
