// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_portfolio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfilePortfolioModel _$WorkerProfilePortfolioModelFromJson(
  Map<String, dynamic> json,
) => _WorkerProfilePortfolioModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  imageUrls: (json['imageUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  category: json['category'] as String,
  complexity: $enumDecode(_$WorkComplexityEnumMap, json['complexity']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  views: (json['views'] as num).toInt(),
  rating: (json['rating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$WorkerProfilePortfolioModelToJson(
  _WorkerProfilePortfolioModel instance,
) => <String, dynamic>{
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
