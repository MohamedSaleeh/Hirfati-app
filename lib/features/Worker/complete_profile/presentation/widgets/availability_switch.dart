import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';

class AvailabilitySwitch extends StatelessWidget {
  final String formControlName;

  const AvailabilitySwitch({super.key, required this.formControlName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ReactiveSwitchListTile(
          formControlName: formControlName,
          title: Text(
            'Availability'.i18n,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: ReactiveValueListenableBuilder<bool>(
            formControlName: formControlName,
            builder: (context, control, child) {
              return Text(
                control.value == true ? 'Online'.i18n : 'Offline'.i18n,
                style: TextStyle(
                  color: control.value == true
                      ? Colors.green
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          activeColor: colorScheme.onPrimary,
          activeTrackColor: colorScheme.primary,
        ),
      ),
    );
  }
}
