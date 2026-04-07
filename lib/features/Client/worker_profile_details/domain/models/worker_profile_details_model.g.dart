// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfileDetailsModel _$WorkerProfileDetailsModelFromJson(
  Map<String, dynamic> json,
) => _WorkerProfileDetailsModel(
  workerId: json['workerId'] as String,
  userId: json['userId'] as String,
  fullName: json['fullName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  city: json['city'] as String?,
  categoryName: json['categoryName'] as String,
  categoryIcon: json['categoryIcon'] as String?,
  experienceYears: (json['experienceYears'] as num).toInt(),
  bio: json['bio'] as String,
  priceMin: (json['priceMin'] as num).toDouble(),
  priceMax: (json['priceMax'] as num).toDouble(),
  ratingAverage: (json['ratingAverage'] as num).toDouble(),
  ratingCount: (json['ratingCount'] as num).toInt(),
  completedJobsCount: (json['completedJobsCount'] as num).toInt(),
  approved: json['approved'] as bool,
  profileCompleted: json['profileCompleted'] as bool,
  isFavorite: json['isFavorite'] as bool,
);

Map<String, dynamic> _$WorkerProfileDetailsModelToJson(
  _WorkerProfileDetailsModel instance,
) => <String, dynamic>{
  'workerId': instance.workerId,
  'userId': instance.userId,
  'fullName': instance.fullName,
  'avatarUrl': instance.avatarUrl,
  'city': instance.city,
  'categoryName': instance.categoryName,
  'categoryIcon': instance.categoryIcon,
  'experienceYears': instance.experienceYears,
  'bio': instance.bio,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
  'ratingAverage': instance.ratingAverage,
  'ratingCount': instance.ratingCount,
  'completedJobsCount': instance.completedJobsCount,
  'approved': instance.approved,
  'profileCompleted': instance.profileCompleted,
  'isFavorite': instance.isFavorite,
};
