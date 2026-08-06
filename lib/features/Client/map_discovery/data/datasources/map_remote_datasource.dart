import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../Home_client/domain_models/craftsman_model.dart';
import '../../../Home_client/domain_models/category_model.dart';

const _kWorkerSelect = '''
  id,
  rating_average,
  price_min,
  is_available,
  profiles (
    id,
    full_name,
    avatar_url,
    city,
    latitude,
    longitude
  ),
  categories (
    name
  )
''';

abstract class MapRemoteDatasource {
  Future<List<CraftsmanModel>> fetchNearbyCraftsmen();
  Future<List<CategoryModel>> fetchCategories();
}

class MapSupabaseDatasourceImpl implements MapRemoteDatasource {
  final SupabaseClient _client;

  MapSupabaseDatasourceImpl(this._client);

  @override
  Future<List<CraftsmanModel>> fetchNearbyCraftsmen() async {
    // Fetch all approved workers and filter client-side for non-null location.
    final response = await _client
        .from('workers')
        .select(_kWorkerSelect)
        .eq('approved', true)
        .limit(100); // Higher limit since we'll filter

    return _mapWorkerRows(response as List<dynamic>).where((c) {
      return c.latitude != null && c.longitude != null;
    }).toList();
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _client
        .from('categories')
        .select(
          'id, name, icon, category_translations('
          'category_id, locale, name, search_terms, created_at, updated_at)',
        )
        .order('name');

    return (response as List<dynamic>)
        .map(
          (e) => CategoryModel.fromSupabaseRow(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  List<CraftsmanModel> _mapWorkerRows(List<dynamic> rows) {
    final result = <CraftsmanModel>[];
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      if (map['profiles'] == null) continue;
      result.add(CraftsmanModel.fromWorkerRow(map));
    }
    return result;
  }
}
