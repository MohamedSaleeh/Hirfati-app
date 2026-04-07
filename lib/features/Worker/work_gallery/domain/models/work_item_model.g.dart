// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkItemModel _$WorkItemModelFromJson(Map<String, dynamic> json) =>
    _WorkItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      category: json['category'] as String,
      complexity: $enumDecode(_$WorkComplexityEnumMap, json['complexity']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      views: (json['views'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WorkItemModelToJson(_WorkItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrls': instance.imageUrls,
      'category': instance.category,
      'complexity': _$WorkComplexityEnumMap[instance.complexity]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'views': instance.views,
      'rating': instance.rating,
    };

const _$WorkComplexityEnumMap = {
  WorkComplexity.standard: 'standard',
  WorkComplexity.high: 'high',
  WorkComplexity.critical: 'critical',
};
