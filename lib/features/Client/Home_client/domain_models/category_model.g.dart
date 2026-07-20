// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      translations: json['category_translations'] == null
          ? const <CategoryTranslationModel>[]
          : _categoryTranslationsFromJson(json['category_translations']),
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'category_translations': instance.translations,
    };

_CategoryTranslationModel _$CategoryTranslationModelFromJson(
  Map<String, dynamic> json,
) => _CategoryTranslationModel(
  categoryId: json['category_id'] as String,
  locale: json['locale'] as String,
  name: json['name'] as String,
  searchTerms: json['search_terms'] == null
      ? const <String>[]
      : _searchTermsFromJson(json['search_terms']),
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$CategoryTranslationModelToJson(
  _CategoryTranslationModel instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'locale': instance.locale,
  'name': instance.name,
  'search_terms': instance.searchTerms,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
