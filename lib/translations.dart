import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  // Start with English translations
  static Translations _t = Translations.byLocale("en-US");

  // Load Arabic from JSON at runtime
  static Future<void> loadArabicFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/translations/ar.json',
      );
      final Map<String, dynamic> map = json.decode(jsonString);

      // Combine Arabic into _t
      _t =
          _t +
          {"ar-SA": map.map((key, value) => MapEntry(key, value.toString()))};
      // ignore: empty_catches
    } catch (e) {}
  }

  String get i18n => localize(this, _t);
  String plural(value) => localizePlural(value, this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
