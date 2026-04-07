import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final loginFormProvider = Provider.autoDispose<FormGroup>((ref) {
  return FormGroup({
    'email': FormControl<String>(
      validators: [
        Validators.required,
        Validators.email,
        Validators.minLength(3),
      ],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(6)],
    ),
  });
});
