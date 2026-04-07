// lib/features/account_settings/presentation/providers/account_settings_form_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'account_settings_provider.dart';

class IntToStringValueAccessor extends ControlValueAccessor<int, String> {
  @override
  String modelToViewValue(int? modelValue) {
    return modelValue?.toString() ?? '';
  }

   @override
  int? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) return null;
    return int.tryParse(viewValue);
  }
}

final accountSettingsFormProvider = Provider<FormGroup>((ref) {
  final settingsAsync = ref.watch(accountSettingsProvider);

  return settingsAsync.when(
    data: (settings) {
      return FormGroup({
        'fullName': FormControl<String>(
          value: settings.fullName,
          validators: [Validators.required],
        ),
        'phone': FormControl<String>(
          value: settings.phone,
          validators: [
            Validators.pattern(r'^[0-9]{10,15}$'),
          ],
        ),
        'city': FormControl<String>(
          value: settings.city,
        ),
        'experienceYears': FormControl<int>(
          value: settings.experienceYears,
          validators: [
            Validators.min(0),
            Validators.max(50),
          ],
        ),
        'bio': FormControl<String>(
          value: settings.bio,
        ),
      });
    },
    loading: () => FormGroup({
      'fullName': FormControl<String>(),
      'phone': FormControl<String>(),
      'city': FormControl<String>(),
      'experienceYears': FormControl<int>(),
      'bio': FormControl<String>(),
    }),
    error: (_, __) => FormGroup({
      'fullName': FormControl<String>(),
      'phone': FormControl<String>(),
      'city': FormControl<String>(),
      'experienceYears': FormControl<int>(),
      'bio': FormControl<String>(),
    }),
  );
});

final intToStringValueAccessorProvider = Provider<IntToStringValueAccessor>(
  (ref) => IntToStringValueAccessor(),
);