import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../profile/presentation/providers/client_profile_provider.dart';

final editProfileFormProvider = Provider<FormGroup>((ref) {
  final profileAsync = ref.watch(clientProfileProvider);

  return profileAsync.when(
    data: (profile) {
      return FormGroup({
        'fullName': FormControl<String>(
          value: profile.fullName ?? '',
          validators: [Validators.required],
        ),
        'phoneNumber': FormControl<String>(
          value: profile.phoneNumber ?? '',
          validators: [
            Validators.required,
            Validators.pattern(r'^[0-9]{10,15}$'),
          ],
        ),
      });
    },
    loading: () => FormGroup({}),
    error: (_, __) => FormGroup({}),
  );
});
