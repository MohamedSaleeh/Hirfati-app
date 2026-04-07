// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerCategoryModel _$WorkerCategoryModelFromJson(Map<String, dynamic> json) =>
    _WorkerCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WorkerCategoryModelToJson(
  _WorkerCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
};
