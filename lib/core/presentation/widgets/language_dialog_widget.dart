import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../translations.dart';
import '../providers/language_provider.dart';

class LanguageDialogWidget extends ConsumerWidget {
  const LanguageDialogWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text("Select Language".i18n),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            selectedTileColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            selected: I18n.locale.languageCode == "en",
            leading: const Icon(Icons.language),
            title: Text('English'.i18n),
            onTap: () async {
              ref.read(language_provider.notifier).state = 'en';
              SharedPreferences languagePrefs =
                  await SharedPreferences.getInstance();
              languagePrefs.setString('language', 'en');

              I18n.of(context).locale = const Locale('en', 'US');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            selectedTileColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            selected: I18n.locale.languageCode == "ar",
            leading: const Icon(Icons.language),
            title: Text('Arabic'.i18n),
            onTap: () async {
              ref.read(language_provider.notifier).state = 'ar';
              SharedPreferences languagePrefs =
                  await SharedPreferences.getInstance();
              languagePrefs.setString('language', 'ar');
              I18n.of(context).locale = const Locale('ar', 'SA');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
