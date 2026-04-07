// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileDataModel _$ProfileDataModelFromJson(Map<String, dynamic> json) =>
    _ProfileDataModel(
      id: json['id'] as String,
      avatarUrl: json['avatar_url'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isProfileCompleted: json['is_profile_completed'] as bool? ?? false,
      hasCompletedOnboarding:
          json['has_completed_onboarding'] as bool? ?? false,
    );

Map<String, dynamic> _$ProfileDataModelToJson(_ProfileDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatar_url': instance.avatarUrl,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_profile_completed': instance.isProfileCompleted,
      'has_completed_onboarding': instance.hasCompletedOnboarding,
    };
