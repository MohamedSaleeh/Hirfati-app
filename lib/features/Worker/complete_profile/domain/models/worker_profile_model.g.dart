// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfileModel _$WorkerProfileModelFromJson(Map<String, dynamic> json) =>
    _WorkerProfileModel(
      categoryId: json['categoryId'] as String,
      experienceYears: (json['experienceYears'] as num).toInt(),
      bio: json['bio'] as String,
      priceMin: (json['priceMin'] as num).toDouble(),
      priceMax: (json['priceMax'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$WorkerProfileModelToJson(_WorkerProfileModel instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'experienceYears': instance.experienceYears,
      'bio': instance.bio,
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
      'isAvailable': instance.isAvailable,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
