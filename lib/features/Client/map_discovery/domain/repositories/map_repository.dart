import '../../../Home_client/domain_models/craftsman_model.dart';
import '../../../Home_client/domain_models/category_model.dart';

abstract class MapRepository {
  Future<List<CraftsmanModel>> getNearbyCraftsmen();
  Future<List<CategoryModel>> getCategories();
}
