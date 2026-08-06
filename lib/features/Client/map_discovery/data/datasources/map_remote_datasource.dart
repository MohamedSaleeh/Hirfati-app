import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Home_client/data/datasources/home_client_supabase_datasource.dart';
import '../../../Home_client/domain_models/craftsman_model.dart';

abstract class MapRemoteDatasource {
  Future<List<CraftsmanModel>> fetchNearbyCraftsmen();
}

class MapSupabaseDatasourceImpl implements MapRemoteDatasource {
  final SupabaseClient _client;

  MapSupabaseDatasourceImpl(this._client);

  @override
  Future<List<CraftsmanModel>> fetchNearbyCraftsmen() async {
    // Fetch all approved workers and filter client-side for non-null location.
    final response = await _client
        .from('workers')
        .select(kHomeClientWorkerSelect)
        .eq('approved', true)
        .limit(100); // Higher limit since we'll filter

    return _mapWorkerRows(response as List<dynamic>).where((c) {
      return c.latitude != null && c.longitude != null;
    }).toList();
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
