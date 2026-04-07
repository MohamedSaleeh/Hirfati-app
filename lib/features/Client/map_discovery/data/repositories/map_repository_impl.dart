import '../../domain/repositories/map_repository.dart';
import '../datasources/map_remote_datasource.dart';
import '../../../Home_client/domain_models/craftsman_model.dart';
import '../../../Home_client/domain_models/category_model.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDatasource _remoteDatasource;

  MapRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<CraftsmanModel>> getNearbyCraftsmen() {
    return _remoteDatasource.fetchNearbyCraftsmen();
  }

  @override
  Future<List<CategoryModel>> getCategories() {
    return _remoteDatasource.fetchCategories();
  }
}
