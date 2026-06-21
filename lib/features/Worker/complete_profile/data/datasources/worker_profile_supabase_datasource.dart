import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/category_model.dart';
import '../../domain/models/worker_profile_model.dart';

class WorkerProfileSupabaseDatasource {
  final SupabaseClient _client;

  WorkerProfileSupabaseDatasource(this._client);

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _client
        .from('categories')
        .select('id, name, icon')
        .order('name');

    return (response as List<dynamic>)
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> submitProfile(WorkerProfileModel profile) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User is not logged in.');
    }

    try {

      await _client.from('workers').insert({
        'user_id': userId,
        'category_id': profile.categoryId,
        'experience_years': profile.experienceYears,
        'bio': profile.bio,
        'price_min': profile.priceMin,
        'price_max': profile.priceMax,
        'is_available': profile.isAvailable,
        'approved': false,
        'profile_completed': true,
      });

      await _client
          .from('profiles')
          .update({
            'latitude': profile.latitude,
            'longitude': profile.longitude,
          })
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }


}
