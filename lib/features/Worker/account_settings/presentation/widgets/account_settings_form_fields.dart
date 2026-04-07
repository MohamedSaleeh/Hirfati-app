import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../providers/account_settings_form_provider.dart';
import 'account_settings_section.dart';

class AccountSettingsFormFields extends ConsumerWidget {
  const AccountSettingsFormFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final form = ref.watch(accountSettingsFormProvider);
    final numAccessor = ref.watch(intToStringValueAccessorProvider);

    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          AccountSettingsSection(
            title: 'personal_information'.i18n,
            icon: Icons.person_outline,
            children: [
              _buildTextField(
                context: context,
                formControlName: 'fullName',
                label: 'full_name'.i18n,
                icon: Icons.badge_outlined,
                validationMessage: 'name_required'.i18n,
                validationType: ValidationMessage.required,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                formControlName: 'phone',
                label: 'phone_number'.i18n,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validationMessage: 'invalid_phone'.i18n,
                validationType: ValidationMessage.pattern,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                formControlName: 'city',
                label: 'city'.i18n,
                icon: Icons.location_city_outlined,
              ),
            ],
          ),
          const SizedBox(height: 24),

          AccountSettingsSection(
            title: 'professional_information'.i18n,
            icon: Icons.work_outline,
            children: [
              _buildNumberField(
                context: context,
                formControlName: 'experienceYears',
                label: 'experience_years'.i18n,
                icon: Icons.timeline_outlined,
                valueAccessor: numAccessor,
                validationMessages: {
                  ValidationMessage.min: (_) => 'min_experience'.i18n,
                  ValidationMessage.max: (_) => 'max_experience'.i18n,
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context: context,
                formControlName: 'bio',
                label: 'bio'.i18n,
                icon: Icons.description_outlined,
                maxLines: 4,
                hint: 'tell_about_your_experience'.i18n,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    BuildContext? context,
    required String formControlName,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
    String? validationMessage,
    String? validationType,
  }) {
    final theme = Theme.of(context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ReactiveTextField<String>(
          formControlName: formControlName,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: TextStyle(color: theme.colorScheme.onSurface),
          validationMessages:
              validationMessage != null && validationType != null
              ? {validationType: (_) => validationMessage}
              : {},
        ),
      ],
    );
  }

  Widget _buildNumberField({
    BuildContext? context,
    required String formControlName,
    required String label,
    required IconData icon,
    required ControlValueAccessor<int, String> valueAccessor,
    required Map<String, String Function(Object)> validationMessages,
  }) {
    final theme = Theme.of(context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ReactiveTextField<int>(
          formControlName: formControlName,
          keyboardType: TextInputType.number,
          valueAccessor: valueAccessor,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: TextStyle(color: theme.colorScheme.onSurface),
          validationMessages: validationMessages,
        ),
      ],
    );
  }
}
