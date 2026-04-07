import 'package:freezed_annotation/freezed_annotation.dart';

part 'craftsman_model.freezed.dart';
part 'craftsman_model.g.dart';

/// Domain model for a worker shown on the Home Client screen.
///
/// Fields are populated from a Supabase relational join:
///   workers → profiles (profile data) + categories (profession name)
@freezed
abstract class CraftsmanModel with _$CraftsmanModel {
  const factory CraftsmanModel({
    /// workers.id
    required String id,

    /// services.id - the first/default service for this worker
    String? serviceId,

    /// workers.category_id (mapped to services/category selection)
    String? categoryId,

    /// profiles.full_name
    required String name,

    /// profiles.avatar_url
    String? avatarUrl,

    /// categories.name  →  profession label shown in UI
    String? profession,

    /// workers.rating_average
    @Default(0.0) double rating,

    /// Computed client-side from location delta (not from DB)
    @Default(0.0) double distance,

    /// workers.hourly_rate - السعر بالساعة من قاعدة البيانات
    @Default(0.0) double hourlyPrice,

    /// أقل سعر للخدمات (إذا وجدت)
    @Default(0.0) double minServicePrice,

    /// هل يوجد خدمات محددة لهذا الحرفي؟
    @Default(false) bool hasServices,

    /// True when the worker is newly added (no ratings yet)
    @Default(false) bool isNew,

    /// profiles.latitude
    double? latitude,

    /// profiles.longitude
    double? longitude,

    /// profiles.city
    String? city,
  }) = _CraftsmanModel;

  /// Standard JSON factory (used internally by Freezed / json_serializable).
  factory CraftsmanModel.fromJson(Map<String, dynamic> json) =>
      _$CraftsmanModelFromJson(json);

  factory CraftsmanModel.fromWorkerRow(Map<String, dynamic> row) {
    final profile = (row['profiles'] as Map<String, dynamic>?) ?? {};
    final category = (row['categories'] as Map<String, dynamic>?) ?? {};
    final services = (row['services'] as List?) ?? [];

    // جلب جميع الخدمات
    final serviceList = services
        .map((s) => Map<String, dynamic>.from(s as Map))
        .toList();
    final hasServices = serviceList.isNotEmpty;

    // حساب أقل سعر للخدمات
    double minServicePrice = 0.0;
    String? firstServiceId;
    String? firstServiceName;

    if (serviceList.isNotEmpty) {
      // أقل سعر
      final prices = serviceList
          .map((s) => (s['price'] as num?)?.toDouble() ?? 0.0)
          .toList();
      minServicePrice = prices.reduce((a, b) => a < b ? a : b);

      // أول خدمة (للعرض الافتراضي)
      final firstService = serviceList.first;
      firstServiceId = firstService['id'] as String?;
      firstServiceName = firstService['title'] as String?;
    }

    final rating = (row['rating_average'] as num?)?.toDouble() ?? 0.0;

    // ✅ استخدام hourly_rate من قاعدة البيانات
    final hourlyRate =
        (row['hourly_rate'] as num?)?.toDouble() ??
        (row['price_min'] as num?)?.toDouble() ??
        0.0;

    print("AVATAR URL: ${profile['avatar_url']}");

    return CraftsmanModel(
      id: row['id'] as String? ?? '',
      serviceId: firstServiceId,
      categoryId: row['category_id']?.toString(),
      name: profile['full_name'] as String? ?? '',
      avatarUrl: profile['avatar_url'] as String?,
      profession: firstServiceName ?? category['name'] as String?,
      rating: rating,
      hourlyPrice: hourlyRate,
      minServicePrice: minServicePrice,
      hasServices: hasServices,
      isNew: rating == 0.0,
      latitude: (profile['latitude'] as num?)?.toDouble(),
      longitude: (profile['longitude'] as num?)?.toDouble(),
      city: profile['city'] as String?,
    );
  }
}
