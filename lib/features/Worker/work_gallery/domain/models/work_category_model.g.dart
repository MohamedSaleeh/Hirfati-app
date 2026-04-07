// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkCategoryModel _$WorkCategoryModelFromJson(Map<String, dynamic> json) =>
    _WorkCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$WorkCategoryModelToJson(_WorkCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'isSelected': instance.isSelected,
    };
