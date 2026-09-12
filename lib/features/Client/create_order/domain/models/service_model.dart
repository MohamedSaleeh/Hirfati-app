import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';

@freezed
abstract class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    required String title,
    String? description,
    required double price,
    int? durationMinutes,
    String? categoryId,
    @Default(<ServiceTranslationModel>[])
    List<ServiceTranslationModel> translations,
  }) = _ServiceModel;
}

class ServiceTranslationModel {
  final String locale;
  final String title;
  final String? description;

  const ServiceTranslationModel({
    required this.locale,
    required this.title,
    this.description,
  });

  factory ServiceTranslationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceTranslationModel(
      locale: json['locale']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}

String resolveServiceTitle(
  ServiceModel service,
  String locale,
) {
  final language = _normalizeServiceLocale(locale);

  for (final translation in service.translations) {
    if (_normalizeServiceLocale(translation.locale) == language &&
        translation.title.trim().isNotEmpty) {
      return translation.title;
    }
  }

  return service.title;
}

String? resolveServiceDescription(
  ServiceModel service,
  String locale,
) {
  final language = _normalizeServiceLocale(locale);

  for (final translation in service.translations) {
    if (_normalizeServiceLocale(translation.locale) == language) {
      final description = translation.description?.trim();

      if (description != null && description.isNotEmpty) {
        return description;
      }
    }
  }

  return service.description;
}

String _normalizeServiceLocale(String locale) {
  final value = locale.trim().toLowerCase();

  if (value.startsWith('ar')) return 'ar';
  if (value.startsWith('en')) return 'en';

  return value;
}