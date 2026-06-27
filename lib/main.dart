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
import 'theme.dart';
import 'translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    debugPrint(".env loaded successfully");
  } catch (e, st) {
    debugPrint("Failed to load .env: $e");
    debugPrintStack(stackTrace: st);
    rethrow;
  }

  final firebaseApiKey = dotenv.env['FIREBASE_API_KEY'];
  final firebaseAppId = dotenv.env['FIREBASE_APP_ID'];
  final firebaseMessagingSenderId = dotenv.env['FIREBASE_MESSAGING_SENDER_ID'];
  final firebaseProjectId = dotenv.env['FIREBASE_PROJECT_ID'];

  if (firebaseApiKey == null ||
      firebaseAppId == null ||
      firebaseMessagingSenderId == null ||
      firebaseProjectId == null) {
    throw Exception('Missing Firebase values in .env file');
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

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file');
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  if (!kIsWeb) {
    await NotificationService.initialize();
  }

  runApp(
    ProviderScope(child: I18n(autoSaveLocale: true, child: const MyApp())),
  );
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
