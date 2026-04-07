import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToggleThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final toggleThemeNotifierProvider =
    NotifierProvider<ToggleThemeNotifier, ThemeMode>(ToggleThemeNotifier.new);

class FullThemeNotifier extends AsyncNotifier<ThemeMode> {
  static const String _key = 'theme_mode';
  final _prefs = SharedPreferencesAsync();

  ThemeMode _fromString(String? s) => switch (s) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  String _toString(ThemeMode m) => switch (m) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };

  @override
  Future<ThemeMode> build() async => _fromString(await _prefs.getString(_key));

  Future<void> setThemeMode(ThemeMode mode) async {
    state = const AsyncValue.loading();
    try {
      await _prefs.setString(_key, _toString(mode));
      state = AsyncValue.data(mode);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final fullThemeNotifierProvider =
    AsyncNotifierProvider<FullThemeNotifier, ThemeMode>(FullThemeNotifier.new);
