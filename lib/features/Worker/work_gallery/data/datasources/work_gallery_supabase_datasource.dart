import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/work_category_model.dart';
import '../../domain/models/work_item_model.dart';

class WorkGallerySupabaseDatasource {
  final SupabaseClient _client;

  WorkGallerySupabaseDatasource(this._client);

  Future<String?> getWorkerId(String userId) async {
    final response = await _client
        .from('workers')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();
    return response?['id'] as String?;
  }

  Future<List<WorkItemModel>> getWorkItems(String userId) async {
    final workerId = await getWorkerId(userId);
    if (workerId == null) return [];

    final response = await _client
        .from('work_portfolio')
        .select('''
          id,
          title,
          description,
          image_url,
          category,
          complexity,
          views,
          rating,
          created_at
        ''')
        .eq('worker_id', workerId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>).map((json) {
      return WorkItemModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrls: (json['image_url'] as List?)?.cast<String>() ?? [],
        category: json['category'],
        complexity: _parseComplexity(json['complexity']),
        createdAt: DateTime.parse(json['created_at']),
        views: json['views'] as int? ?? 0,
        rating: (json['rating'] as num?)?.toDouble(),
      );
    }).toList();
  }

  Future<List<WorkCategoryModel>> getCategories() async {
    final response = await _client
        .from('categories')
        .select('id, name, icon')
        .order('name');

    return (response as List<dynamic>).map((json) {
      return WorkCategoryModel(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
      );
    }).toList();
  }

  Future<String> uploadWorkImage(
    String workerId,
    String imagePath,
    int index,
  ) async {
    final fileName =
        'work_portfolio/${workerId}_${DateTime.now().millisecondsSinceEpoch}_$index.jpg';

    if (kIsWeb) {
      final response = await http.get(Uri.parse(imagePath));
      final bytes = response.bodyBytes;
      await _client.storage
          .from('work_portfolio')
          .uploadBinary(fileName, bytes);
    } else {
      final file = File(imagePath);
      await _client.storage.from('work_portfolio').upload(fileName, file);
    }

    return _client.storage.from('work_portfolio').getPublicUrl(fileName);
  }

  Future<WorkItemModel> addWorkItem({
    required String workerId,
    required String title,
    required String description,
    required List<String> imageUrls,
    required String category,
    required String complexity,
  }) async {
    final response = await _client
        .from('work_portfolio')
        .insert({
          'worker_id': workerId,
          'title': title,
          'description': description,
          'image_url': imageUrls,
          'category': category,
          'complexity': complexity,
          'views': 0,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return WorkItemModel(
      id: response['id'],
      title: response['title'],
      description: response['description'],
      imageUrls: (response['image_url'] as List?)?.cast<String>() ?? [],
      category: response['category'],
      complexity: _parseComplexity(response['complexity']),
      createdAt: DateTime.parse(response['created_at']),
      views: response['views'] as int? ?? 0,
      rating: (response['rating'] as num?)?.toDouble(),
    );
  }

  Future<void> deleteWorkItem(String workId) async {
    await _client.from('work_portfolio').delete().eq('id', workId);
  }

  Future<void> incrementViews(String workId) async {
    await _client.rpc('increment_work_views', params: {'work_id': workId});
  }

  WorkComplexity _parseComplexity(String? complexity) {
    switch (complexity) {
      case 'high':
        return WorkComplexity.high;
      case 'critical':
        return WorkComplexity.critical;
      default:
        return WorkComplexity.standard;
    }
  }
}
