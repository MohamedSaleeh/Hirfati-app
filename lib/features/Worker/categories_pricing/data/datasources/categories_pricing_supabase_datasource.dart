import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/worker_category_model.dart';
import '../../domain/models/worker_service_model.dart';


class CategoriesPricingSupabaseDatasource {
  final SupabaseClient _client;

  CategoriesPricingSupabaseDatasource(this._client);

  Future<String?> getWorkerId(String userId) async {
    final response = await _client
        .from('workers')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();
    return response?['id'] as String?;
  }

  Future<List<WorkerCategoryModel>> getWorkerCategories(String userId) async {
    final workerId = await getWorkerId(userId);
    if (workerId == null) return [];

    final response = await _client
        .from('workers')
        .select('''
          category_id,
          price_min,
          price_max,
          categories (
            id,
            name,
            icon
          )
        ''')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return [];

    final category = response['categories'] as Map<String, dynamic>?;
    if (category == null) return [];

    return [
      WorkerCategoryModel(
        id: category['id'],
        name: category['name'],
        icon: category['icon'],
        priceMin: (response['price_min'] as num?)?.toDouble(),
        priceMax: (response['price_max'] as num?)?.toDouble(),
      ),
    ];
  }

  Future<List<WorkerServiceModel>> getWorkerServices(String workerId) async {
    final response = await _client
        .from('services')
        .select('id, title, description, price, duration_minutes')
        .eq('worker_id', workerId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>).map((json) {
      return WorkerServiceModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        durationMinutes: json['duration_minutes'],
      );
    }).toList();
  }

  Future<void> updateCategoryPriceRange(
    String workerId,
    String categoryId,
    double priceMin,
    double priceMax,
  ) async {
    await _client
        .from('workers')
        .update({
          'price_min': priceMin,
          'price_max': priceMax,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', workerId);
  }

  Future<WorkerServiceModel> addService(
    String workerId,
    String title,
    double price,
    String? description,
    int? durationMinutes,
  ) async {
    final response = await _client
        .from('services')
        .insert({
          'worker_id': workerId,
          'title': title,
          'description': description,
          'price': price,
          'duration_minutes': durationMinutes,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return WorkerServiceModel(
      id: response['id'],
      title: response['title'],
      description: response['description'],
      price: (response['price'] as num).toDouble(),
      durationMinutes: response['duration_minutes'],
    );
  }

  Future<WorkerServiceModel> updateService(WorkerServiceModel service) async {
    final response = await _client
        .from('services')
        .update({
          'title': service.title,
          'description': service.description,
          'price': service.price,
          'duration_minutes': service.durationMinutes,
        })
        .eq('id', service.id)
        .select()
        .single();

    return WorkerServiceModel(
      id: response['id'],
      title: response['title'],
      description: response['description'],
      price: (response['price'] as num).toDouble(),
      durationMinutes: response['duration_minutes'],
    );
  }

  Future<void> deleteService(String serviceId) async {
    await _client.from('services').delete().eq('id', serviceId);
  }
}