import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hirfati/router.dart';
import 'core/presentation/providers/theme_provider.dart';
import 'core/services/notification_service.dart';
import 'core/utils/app_logger.dart';
import 'theme.dart';
import 'translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    AppLogger.info('Local environment file loaded');
  } catch (_) {
    AppLogger.warning(
      'Local environment file was not loaded; using dart-define values.',
    );
  }

  final firebaseApiKey = _configValue('FIREBASE_API_KEY');
  final firebaseAppId = _configValue('FIREBASE_APP_ID');
  final firebaseMessagingSenderId = _configValue(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  final firebaseProjectId = _configValue('FIREBASE_PROJECT_ID');

  if (firebaseApiKey == null ||
      firebaseAppId == null ||
      firebaseMessagingSenderId == null ||
      firebaseProjectId == null) {
    throw Exception(
      'Missing Firebase configuration. Provide public Firebase values with --dart-define or local development environment values.',
    );
  }

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseApiKey,
      appId: firebaseAppId,
      messagingSenderId: firebaseMessagingSenderId,
      projectId: firebaseProjectId,
    ),
  );

  await Localization.loadArabicFromJson();

  final supabaseUrl = _configValue('SUPABASE_URL');
  final supabaseAnonKey = _configValue('SUPABASE_ANON_KEY');

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception(
      'Missing Supabase configuration. Provide SUPABASE_URL and SUPABASE_ANON_KEY with --dart-define or local development environment values.',
    );
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  if (!kIsWeb) {
    await NotificationService.initialize();
  }

  runApp(
    ProviderScope(child: I18n(autoSaveLocale: true, child: const MyApp())),
  );
}

String? _configValue(String key) {
  final dartDefineValue = switch (key) {
    'SUPABASE_URL' => const String.fromEnvironment('SUPABASE_URL'),
    'SUPABASE_ANON_KEY' => const String.fromEnvironment('SUPABASE_ANON_KEY'),
    'FIREBASE_API_KEY' => const String.fromEnvironment('FIREBASE_API_KEY'),
    'FIREBASE_APP_ID' => const String.fromEnvironment('FIREBASE_APP_ID'),
    'FIREBASE_MESSAGING_SENDER_ID' => const String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
    ),
    'FIREBASE_PROJECT_ID' => const String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
    ),
    _ => '',
  };

  if (dartDefineValue.trim().isNotEmpty) return dartDefineValue.trim();

  final dotenvValue = dotenv.env[key]?.trim();
  if (dotenvValue != null && dotenvValue.isNotEmpty) return dotenvValue;

  return null;
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeModeAsync = ref.watch(fullThemeNotifierProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Hirfati',
      theme: AppTheme.light.copyWith(),
      darkTheme: AppTheme.dark,
      themeMode: themeModeAsync.when(
        data: (mode) => mode,
        loading: () => ThemeMode.system,
        error: (_, _) => ThemeMode.system,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("en", "US"), Locale("ar", "SA")],
      locale: I18n.locale,

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
          child: child!,
        );
      },
    );
  }
}
