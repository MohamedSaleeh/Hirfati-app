// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountSettingsModel _$AccountSettingsModelFromJson(
  Map<String, dynamic> json,
) => _AccountSettingsModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  city: json['city'] as String?,
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  bio: json['bio'] as String?,
);

Map<String, dynamic> _$AccountSettingsModelToJson(
  _AccountSettingsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'fullName': instance.fullName,
  'phone': instance.phone,
  'email': instance.email,
  'avatarUrl': instance.avatarUrl,
  'city': instance.city,
  'experienceYears': instance.experienceYears,
  'bio': instance.bio,
};
