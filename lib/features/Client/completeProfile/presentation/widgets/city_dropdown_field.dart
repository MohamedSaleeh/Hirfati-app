import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../translations.dart';
import '../providers/profile_setup_controller.dart';

const _kSaudiCities = [
  'Riyadh',
  'Jeddah',
  'Mecca',
  'Medina',
  'Dammam',
  'Khobar',
  'Dhahran',
  'Taif',
  'Tabuk',
  'Abha',
  'Najran',
  'Hail',
  'Jizan',
  'Yanbu',
  'Qatif',
  'Buraidah',
  'Al Kharj',
  'Al Hofuf',
];

class CityDropdownField extends ConsumerWidget {
  const CityDropdownField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(profileSetupProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'المدينة',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ReactiveDropdownField<String>(
          formControlName: 'city',
          decoration: InputDecoration(
            hintText: 'Select your city'.i18n,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          items: _kSaudiCities
              .map(
                (city) => DropdownMenuItem<String>(
                  value: city,
                  child: Text(
                    city,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (control) {
            if (control.value != null) {
              controller.setCity(control.value!);
            }
          },
          validationMessages: {
            ValidationMessage.required: (_) => 'Please select a city',
          },
        ),
      ],
    );
  }
}
