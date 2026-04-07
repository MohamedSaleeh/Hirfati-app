import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/worker_profile_model.dart';

class WorkerProfileSupabaseDatasource {
  final SupabaseClient _client;

  WorkerProfileSupabaseDatasource(this._client);

  Future<Map<String, dynamic>> _getWorkerData(String userId) async {
    final response = await _client
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
        is_available,
        approved,
        profile_completed,
        categories (
          name
        )
      ''')
        .eq('user_id', userId)
        .maybeSingle();

    print('🔵 [WorkerProfile] Worker data response: $response'); // للتحقق

    if (response == null) {
      // ✅ إذا لم يجد الحرفي، حاول إنشاء سجل افتراضي
      print('⚠️ [WorkerProfile] Worker not found, creating default...');
      return {
        'id': '',
        'user_id': userId,
        'experience_years': 0,
        'bio': null,
        'price_min': 0,
        'price_max': 0,
        'rating_average': 0,
        'rating_count': 0,
        'is_available': false,
        'approved': false,
        'profile_completed': false,
        'categories': null,
      };
    }

    return Map<String, dynamic>.from(response as Map);
  }

  Future<Map<String, dynamic>> _getProfileData(String userId) async {
    final response = await _client
        .from('profiles')
        .select('''
          id,
          full_name,
          avatar_url,
          role
        ''')
        .eq('id', userId)
        .single();

    return Map<String, dynamic>.from(response as Map);
  }

  Future<int> getCompletedJobsCount(String workerId) async {
    final response = await _client
        .from('orders')
        .select('id')
        .eq('worker_id', workerId)
        .eq('status', 'completed');

    final orders = response as List<dynamic>;
    return orders.length;
  }

  Future<int> getTotalWorkingHours(String workerId) async {
    // حساب إجمالي ساعات العمل من جدول services
    final response = await _client
        .from('services')
        .select('duration_minutes')
        .eq('worker_id', workerId);

    final services = response as List<dynamic>;
    int totalMinutes = 0;

    for (final service in services) {
      final duration = service['duration_minutes'] as int?;
      if (duration != null) {
        totalMinutes += duration;
      }
    }

    return totalMinutes ~/ 60; // تحويل إلى ساعات
  }

  Future<WorkerProfileModel> getWorkerProfile(String userId) async {
    print('🔵 [WorkerProfile] Getting profile for user: $userId');

    final workerData = await _getWorkerData(userId);
    final profileData = await _getProfileData(userId);

    final workerId = workerData['id'] as String? ?? '';

    // ✅ إذا لم يكن هناك workerId، اعرض ملف شخصي افتراضي
    if (workerId.isEmpty) {
      print(
        '⚠️ [WorkerProfile] No worker record found, returning default profile',
      );
      return WorkerProfileModel(
        id: '',
        userId: userId,
        fullName: profileData['full_name'] as String? ?? 'Worker',
        avatarUrl: profileData['avatar_url'] as String?,
        role: profileData['role'] as String? ?? 'worker',
        profession: null,
        rating: 0.0,
        reviewCount: 0,
        completedJobs: 0,
        totalHours: 0,
        isVerified: false,
        isAvailable: false,
        bio: null,
        priceMin: 0.0,
        priceMax: 0.0,
      );
    }

    final completedJobs = await getCompletedJobsCount(workerId);
    final totalHours = await getTotalWorkingHours(workerId);
    final category = workerData['categories'] as Map<String, dynamic>?;

    return WorkerProfileModel(
      id: workerId,
      userId: userId,
      fullName: profileData['full_name'] as String? ?? 'Worker',
      avatarUrl: profileData['avatar_url'] as String?,
      role: profileData['role'] as String? ?? 'worker',
      profession: category?['name'] as String?,
      rating: (workerData['rating_average'] as num?)?.toDouble() ?? 0.0,
      reviewCount: workerData['rating_count'] as int? ?? 0,
      completedJobs: completedJobs,
      totalHours: totalHours,
      isVerified: workerData['approved'] as bool? ?? false,
      isAvailable: workerData['is_available'] as bool? ?? false,
      bio: workerData['bio'] as String?,
      priceMin: (workerData['price_min'] as num?)?.toDouble() ?? 0.0,
      priceMax: (workerData['price_max'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
