import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utils/distance_utils.dart';
import '../../../../../translations.dart';
import '../../domain_models/category_model.dart';
import '../../domain_models/craftsman_model.dart';

/// The Supabase relational select string used for every worker query.
///
/// Joins: workers → profiles (profile data) + categories (profession) + services
const _kWorkerSelect = '''
  id,
  category_id,
  rating_average,
  price_min,
  hourly_rate, 
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
  ),
  services (
    id,
    title,
    price
  )
''';

class HomeClientSupabaseDatasource {
  final SupabaseClient _client;

  HomeClientSupabaseDatasource(this._client);

  // --------------------------------------------------
  // Fetch all categories
  // --------------------------------------------------
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _client
        .from('categories')
        .select('id, name, icon')
        .order('name');

    return (response as List<dynamic>)
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // --------------------------------------------------
  // Fetch worker's location by worker ID (used for distance calculations)
  // Joins: workers → profiles (via workers.user_id = profiles.id)
  // --------------------------------------------------

  Future<(double? lat, double? lng)?> _getWorkerLocation(
    String workerId,
  ) async {
    try {
      print('🔍 Getting worker location for worker ID: $workerId');

      // جلب worker ثم ربطه بـ profiles
      final worker = await _client
          .from('workers')
          .select('''
            user_id,
            profiles!workers_user_id_fkey (
              latitude,
              longitude
            )
          ''')
          .eq('id', workerId)
          .maybeSingle();

      if (worker == null) {
        print('⚠️ Worker not found');
        return null;
      }

      final profile = worker['profiles'] as Map<String, dynamic>?;
      if (profile != null) {
        final lat = profile['latitude'] as double?;
        final lng = profile['longitude'] as double?;
        if (lat != null && lng != null) {
          print('✅ Worker location: lat=$lat, lng=$lng');
          return (lat, lng);
        }
      }

      print('⚠️ Worker location not found in profiles');
      return null;
    } catch (e) {
      print('❌ Error getting worker location: $e');
      return null;
    }
  }

  Future<(double? lat, double? lng)?> _getClientLocation(String? userId) async {
    if (userId == null) return null;

    try {
      print('🔍 Getting client location for user ID: $userId');

      final profile = await _client
          .from('profiles')
          .select('latitude, longitude')
          .eq('id', userId)
          .maybeSingle();

      if (profile == null) {
        print('⚠️ Client profile not found');
        return null;
      }

      final lat = profile['latitude'] as double?;
      final lng = profile['longitude'] as double?;

      if (lat != null && lng != null) {
        print('✅ Client location: lat=$lat, lng=$lng');
        return (lat, lng);
      } else {
        print('⚠️ Client location data is incomplete');
        return null;
      }
    } catch (e) {
      print('❌ Error getting client location: $e');
      return null;
    }
  }

  // --------------------------------------------------
  // Fetch recommended craftsmen
  // Joins: workers → profiles + categories + services
  // Ordered by rating descending, only approved workers
  // --------------------------------------------------
  Future<List<CraftsmanModel>> fetchRecommendedCraftsmen() async {
    final response = await _client
        .from('workers')
        .select(_kWorkerSelect)
        .eq('approved', true)
        .order('rating_average', ascending: false)
        .limit(20);

    final result = <CraftsmanModel>[];

    final currentClientUserId = _client.auth.currentUser?.id;
    final currentClientLocation = await _getClientLocation(currentClientUserId);

    for (var json in response as List<dynamic>) {
      final map = Map<String, dynamic>.from(json as Map);
      if (map['profiles'] == null) continue;

      final craftsman = CraftsmanModel.fromWorkerRow(map);

      double distance = 0.0;

      if (currentClientLocation != null &&
          craftsman.latitude != null &&
          craftsman.longitude != null) {
        final workerLocation = await _getWorkerLocation(craftsman.id);
        if (workerLocation != null &&
            workerLocation.$1 != null &&
            workerLocation.$2 != null) {
          distance = DistanceUtils.calculateDistance(
            currentClientLocation.$1!,
            currentClientLocation.$2!,
            workerLocation.$1!,
            workerLocation.$2!,
          );
        }
      }
      result.add(craftsman.copyWith(distance: distance));

      print('📊 Fetched ${(result.length)} workers with services');
    }
    return result;
  }

  // --------------------------------------------------
  // Search craftsmen by name (profiles.full_name) or
  // profession (categories.name) — uses two queries and
  // deduplicates by worker id.
  // --------------------------------------------------
  Future<List<CraftsmanModel>> searchCraftsmen(String query) async {
    if (query.trim().isEmpty) return fetchRecommendedCraftsmen();

    final response = await _client
        .from('workers')
        .select(_kWorkerSelect)
        .eq('approved', true)
        .limit(100);

    final all = _mapWorkerRows(response as List<dynamic>);
    final lq = query.toLowerCase();

    return all.where((c) {
      return (c.name.toLowerCase().contains(lq)) ||
          (c.profession?.toLowerCase().contains(lq) ?? false);
    }).toList();
  }

  // --------------------------------------------------
  // Fetch nearby craftsmen (workers who have location data)
  // --------------------------------------------------
  Future<List<CraftsmanModel>> fetchNearbyCraftsmen() async {
    final response = await _client
        .from('workers')
        .select(_kWorkerSelect)
        .eq('approved', true)
        .limit(30);

    return _mapWorkerRows(response as List<dynamic>)
        .where((c) {
          return c.latitude != null && c.longitude != null;
        })
        .take(12)
        .toList();
  }

  // --------------------------------------------------
  // Fetch current user's city from profiles
  // --------------------------------------------------
  Future<String?> fetchUserCity() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select('city')
        .eq('id', userId)
        .single();

    return response['city'] as String?;
  }

  // --------------------------------------------------
  // Private helpers
  // --------------------------------------------------

  /// Maps a raw Supabase worker join response list to [CraftsmanModel] list.
  /// Rows where the related profiles entry is null are silently skipped.
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
