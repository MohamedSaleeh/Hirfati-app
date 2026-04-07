import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import '../../../translations.dart';

class LanguageDialogWidget extends StatelessWidget {
  const LanguageDialogWidget({super.key});
  @override
  Widget build(BuildContext context) {
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
              I18n.of(context).locale = const Locale('ar', 'SA');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
