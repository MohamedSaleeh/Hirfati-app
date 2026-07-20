import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    String? icon,
    @Default(<CategoryTranslationModel>[])
    @JsonKey(
      name: 'category_translations',
      fromJson: _categoryTranslationsFromJson,
    )
    List<CategoryTranslationModel> translations,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.fromSupabaseRow(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? json['category_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      translations: _categoryTranslationsFromJson(
        json['category_translations'],
      ),
    );
  }
}

@freezed
abstract class CategoryTranslationModel with _$CategoryTranslationModel {
  const factory CategoryTranslationModel({
    @JsonKey(name: 'category_id') required String categoryId,
    required String locale,
    required String name,
    @Default(<String>[])
    @JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson)
    List<String> searchTerms,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _CategoryTranslationModel;

  factory CategoryTranslationModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryTranslationModelFromJson(json);

  factory CategoryTranslationModel.fromSupabaseRow(Map<String, dynamic> json) {
    return CategoryTranslationModel(
      categoryId: json['category_id']?.toString() ?? '',
      locale: json['locale']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      searchTerms: _searchTermsFromJson(json['search_terms']),
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );
  }
}

String resolveCategoryDisplayName(CategoryModel category, String locale) {
  final localeCode = _normalizeLocale(locale);

  for (final translation in category.translations) {
    if (_normalizeLocale(translation.locale) == localeCode &&
        translation.name.trim().isNotEmpty) {
      return translation.name;
    }
  }

  for (final translation in category.translations) {
    if (_normalizeLocale(translation.locale) == 'en' &&
        translation.name.trim().isNotEmpty) {
      return translation.name;
    }
  }

  return category.name;
}

String _normalizeLocale(String locale) {
  final value = locale.trim().toLowerCase();
  if (value.startsWith('ar')) return 'ar';
  if (value.startsWith('en')) return 'en';
  final separatorIndex = value.indexOf(RegExp('[-_]'));
  return separatorIndex == -1 ? value : value.substring(0, separatorIndex);
}

List<CategoryTranslationModel> _categoryTranslationsFromJson(Object? value) {
  if (value is! List) return const <CategoryTranslationModel>[];

  final translations = <CategoryTranslationModel>[];
  for (final item in value) {
    if (item is Map) {
      translations.add(
        CategoryTranslationModel.fromSupabaseRow(
          Map<String, dynamic>.from(item),
        ),
      );
    }
  }
  return translations;
}

List<String> _searchTermsFromJson(Object? value) {
  if (value is! List) return const <String>[];

  return value
      .where((item) => item != null)
      .map((item) => item.toString())
      .where((item) => item.trim().isNotEmpty)
      .toList();
}

DateTime? _dateTimeFromJson(Object? value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
