// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerModel _$WorkerModelFromJson(Map<String, dynamic> json) => _WorkerModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  categoryId: json['category_id'] as String?,
  experienceYears: (json['experience_years'] as num?)?.toInt(),
  bio: json['bio'] as String?,
  priceMin: (json['price_min'] as num?)?.toDouble(),
  priceMax: (json['price_max'] as num?)?.toDouble(),
  ratingAverage: (json['rating_average'] as num?)?.toDouble() ?? 0,
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  isAvailable: json['is_available'] as bool? ?? false,
  approved: json['approved'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$WorkerModelToJson(_WorkerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'experience_years': instance.experienceYears,
      'bio': instance.bio,
      'price_min': instance.priceMin,
      'price_max': instance.priceMax,
      'rating_average': instance.ratingAverage,
      'rating_count': instance.ratingCount,
      'is_available': instance.isAvailable,
      'approved': instance.approved,
      'created_at': instance.createdAt?.toIso8601String(),
    };
