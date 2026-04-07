// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfileModel _$WorkerProfileModelFromJson(Map<String, dynamic> json) =>
    _WorkerProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'worker',
      profession: json['profession'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      completedJobs: (json['completedJobs'] as num?)?.toInt() ?? 0,
      totalHours: (json['totalHours'] as num?)?.toInt() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? false,
      bio: json['bio'] as String?,
      priceMin: (json['priceMin'] as num?)?.toDouble() ?? 0.0,
      priceMax: (json['priceMax'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$WorkerProfileModelToJson(_WorkerProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'role': instance.role,
      'profession': instance.profession,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'completedJobs': instance.completedJobs,
      'totalHours': instance.totalHours,
      'isVerified': instance.isVerified,
      'isAvailable': instance.isAvailable,
      'bio': instance.bio,
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
    };
