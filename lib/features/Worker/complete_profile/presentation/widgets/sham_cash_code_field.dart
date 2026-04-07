import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';

class ShamCashCodeField extends StatelessWidget {
  final String formControlName;

  const ShamCashCodeField({super.key, required this.formControlName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sham Cash Account Code'.i18n,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Enter your Sham Cash account code'.i18n,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ReactiveTextField<String>(
                formControlName: formControlName,
                decoration: InputDecoration(
                  hintText: 'e.g., SHAM123456'.i18n,
                  prefixIcon: const Icon(Icons.qr_code),
                  border: const OutlineInputBorder(),
                  helperText: 'Code must be 6-20 characters (A-Z, 0-9)'.i18n,
                ),
                textCapitalization: TextCapitalization.characters,
                validationMessages: {
                  ValidationMessage.required: (error) =>
                      'Sham Cash code is required'.i18n,
                  ValidationMessage.minLength: (error) =>
                      'Code must be at least 6 characters'.i18n,
                  ValidationMessage.maxLength: (error) =>
                      'Code cannot exceed 20 characters'.i18n,
                  ValidationMessage.pattern: (error) =>
                      'Only uppercase letters and numbers allowed'.i18n,
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
