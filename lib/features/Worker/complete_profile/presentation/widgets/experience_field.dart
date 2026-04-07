import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';

class ExperienceField extends StatelessWidget {
  final String formControlName;

  const ExperienceField({super.key, required this.formControlName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ReactiveTextField<int>(
      formControlName: formControlName,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Years of Experience'.i18n,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        prefixIcon: Icon(Icons.work_outline, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      validationMessages: {
        ValidationMessage.required: (error) => 'This field is required'.i18n,
        ValidationMessage.min: (error) => 'Must be at least 0'.i18n,
      },
    );
  }
}
