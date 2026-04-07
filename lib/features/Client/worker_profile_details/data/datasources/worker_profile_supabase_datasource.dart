import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/worker_profile_details_model.dart';
import '../../domain/models/worker_profile_portfolio_model.dart';
import '../../domain/models/worker_profile_review_model.dart';
import '../../domain/models/worker_profile_service_model.dart';

class WorkerProfileSupabaseDatasource {
  final SupabaseClient _client;

  WorkerProfileSupabaseDatasource(this._client);

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

  Future<int> _getCompletedJobsCount(String workerId) async {
    final response = await _client
        .from('orders')
        .select('id')
        .eq('worker_id', workerId)
        .eq('status', 'completed');

    return (response as List).length;
  }

  Future<WorkerProfileDetailsModel> getWorkerDetails(String workerId) async {
    final workerResponse = await _client
        .from('workers')
        .select('''
          id,
          user_id,
          experience_years,
          bio,
          price_min,
          price_max,
          rating_average,
          rating_count,
          approved,
          profile_completed,
          profiles:user_id (
            full_name,
            avatar_url,
            city
          ),
          categories:category_id (
            name,
            icon
          )
        ''')
        .eq('id', workerId)
        .single();

    final completedJobsCount = await _getCompletedJobsCount(workerId);

    final profiles = workerResponse['profiles'] as Map<String, dynamic>?;
    final categories = workerResponse['categories'] as Map<String, dynamic>?;

    return WorkerProfileDetailsModel(
      workerId: workerResponse['id'],
      userId: workerResponse['user_id'],
      fullName: profiles?['full_name'] ?? '',
      avatarUrl: profiles?['avatar_url'],
      city: profiles?['city'],
      categoryName: categories?['name'] ?? '',
      categoryIcon: categories?['icon'],
      experienceYears: workerResponse['experience_years'] as int? ?? 0,
      bio: workerResponse['bio'] ?? '',
      priceMin: (workerResponse['price_min'] as num?)?.toDouble() ?? 0,
      priceMax: (workerResponse['price_max'] as num?)?.toDouble() ?? 0,
      ratingAverage:
          (workerResponse['rating_average'] as num?)?.toDouble() ?? 0,
      ratingCount: workerResponse['rating_count'] as int? ?? 0,
      completedJobsCount: completedJobsCount,
      approved: workerResponse['approved'] as bool? ?? false,
      profileCompleted: workerResponse['profile_completed'] as bool? ?? false,
      isFavorite: false, // سيتم ملؤه من استعلام آخر
    );
  }

  Future<List<WorkerProfilePortfolioModel>> getWorkerPortfolio(
    String workerId, {
    int limit = 4,
  }) async {
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
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List<dynamic>).map((json) {
      return WorkerProfilePortfolioModel(
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

  Future<List<WorkerProfileServiceModel>> getWorkerServices(
    String workerId,
  ) async {
    final response = await _client
        .from('services')
        .select('id, title, description, price, duration_minutes')
        .eq('worker_id', workerId)
        .order('price', ascending: true);

    return (response as List<dynamic>).map((json) {
      return WorkerProfileServiceModel(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        durationMinutes: json['duration_minutes'] as int? ?? 0,
      );
    }).toList();
  }

  Future<List<WorkerProfileReviewModel>> getWorkerReviews(
    String workerId, {
    int limit = 5,
  }) async {
    final response = await _client
        .from('reviews')
        .select('''
          id,
          rating,
          comment,
          created_at,
          client_id,
          profiles:client_id (
            full_name,
            avatar_url
          )
        ''')
        .eq('worker_id', workerId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List<dynamic>).map((json) {
      final profile = json['profiles'] as Map<String, dynamic>?;

      return WorkerProfileReviewModel(
        id: json['id'],
        clientId: json['client_id'],
        clientName: profile?['full_name'] ?? '',
        clientAvatarUrl: profile?['avatar_url'],
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        comment: json['comment'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
      );
    }).toList();
  }

  Future<bool> isFavorite({
    required String clientId,
    required String workerId,
  }) async {
    final response = await _client
        .from('favorites')
        .select('id')
        .eq('client_id', clientId)
        .eq('worker_id', workerId)
        .maybeSingle();

    return response != null;
  }

  Future<void> addFavorite({
    required String clientId,
    required String workerId,
  }) async {
    await _client.from('favorites').insert({
      'client_id': clientId,
      'worker_id': workerId,
    });
  }

  Future<void> removeFavorite({
    required String clientId,
    required String workerId,
  }) async {
    await _client
        .from('favorites')
        .delete()
        .eq('client_id', clientId)
        .eq('worker_id', workerId);
  }
}
