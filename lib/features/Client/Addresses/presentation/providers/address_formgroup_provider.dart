// lib/features/client_profile/presentation/providers/address_form_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../domain/models/address_model.dart';

final selectedAddressProvider = StateProvider<AddressModel?>((ref) => null);

final addressFormProvider = Provider<FormGroup>((ref) {
  print('🔵 [addressFormProvider] Started');
  final address = ref.watch(selectedAddressProvider);
  print('🔵 [addressFormProvider] address: ${address?.id ?? "null"}');
  
  try {
    final form = FormGroup({
      'label': FormControl<String>(
        value: address?.label ?? '',
        validators: [Validators.required],
      ),
      'fullAddress': FormControl<String>(
        value: address?.fullAddress ?? '',
        validators: [Validators.required],
      ),
      'type': FormControl<AddressType>(
        value: address?.addressType ?? AddressType.home,
      ),
      'city': FormControl<String>(value: address?.city ?? ''),
      'street': FormControl<String>(value: address?.street ?? ''),
      'latitude': FormControl<String>(value: address?.latitude ?? ''),
      'longitude': FormControl<String>(value: address?.longitude ?? ''),
    });
    print('✅ [addressFormProvider] Form created successfully');
    return form;
  } catch (e, stack) {
    print('❌ [addressFormProvider] Error: $e');
    print('📚 Stack: $stack');
    return FormGroup({});
  }
});

final addressFormIsValidProvider = Provider<bool>((ref) {
  final form = ref.watch(addressFormProvider);
  return form.valid;
});

final addressFormDataProvider = Provider<Map<String, dynamic>>((ref) {
  final form = ref.watch(addressFormProvider);
  return {
    'label': form.control('label').value as String?,
    'fullAddress': form.control('fullAddress').value as String?,
    'type': form.control('type').value as AddressType,
    'city': form.control('city').value as String?,
    'street': form.control('street').value as String?,
    'latitude': form.control('latitude').value as String?,
    'longitude': form.control('longitude').value as String?,
  };
});