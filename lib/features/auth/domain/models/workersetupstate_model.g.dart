// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workersetupstate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerSetupState _$WorkerSetupStateFromJson(Map<String, dynamic> json) =>
    _WorkerSetupState(
      categoryId: json['categoryId'] as String? ?? '',
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      bio: json['bio'] as String? ?? '',
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WorkerSetupStateToJson(_WorkerSetupState instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'experienceYears': instance.experienceYears,
      'bio': instance.bio,
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
    };
