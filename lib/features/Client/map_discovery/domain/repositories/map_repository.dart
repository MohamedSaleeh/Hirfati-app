import '../../../Home_client/domain_models/craftsman_model.dart';

abstract class MapRepository {
  Future<List<CraftsmanModel>> getNearbyCraftsmen();
}
