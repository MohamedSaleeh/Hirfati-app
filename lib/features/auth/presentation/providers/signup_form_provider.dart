import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final signupFormProvider = Provider.autoDispose<FormGroup>((ref) {
  return FormGroup(
    {
      'fullName': FormControl<String>(
        value: '',
        validators: [Validators.required, Validators.minLength(3)],
      ),
      'email': FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.minLength(3),
          Validators.email,
        ],
      ),
      'phoneNumber': FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.minLength(9),
          Validators.pattern(r'^\+?[0-9]{7,15}$'),
        ],
      ),
      'password': FormControl<String>(
        value: '',
        validators: [Validators.required, Validators.minLength(6)],
      ),
      'confirmPassword': FormControl<String>(
        value: '',
        validators: [Validators.required, Validators.minLength(6)],
      ),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );
});
