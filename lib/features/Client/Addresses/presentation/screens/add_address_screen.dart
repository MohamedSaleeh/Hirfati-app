import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../../domain/models/address_model.dart';
import '../providers/address_formgroup_provider.dart';
import '../providers/addresses_provider.dart';
import '../widgets/location_map_widget.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    ref.read(selectedAddressProvider.notifier).state = null;
  }

  void _onLocationSelected(LatLng location) {
    debugPrint(
      'Location selected: ${location.latitude}, ${location.longitude}',
    );
  }

  void _onCoordinatesChanged(String latitude, String longitude) {
    final form = ref.read(addressFormProvider);
    form.control('latitude').value = latitude;
    form.control('longitude').value = longitude;
  }

  Future<void> _saveAddress() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final form = ref.read(addressFormProvider);

    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(addressesProvider.notifier);
      final formData = ref.read(addressFormDataProvider);

      final newAddress = AddressModel(
        label: formData['label'] as String,
        addressType: formData['type'] as AddressType,
        fullAddress: formData['fullAddress'] as String,
        city: formData['city'] as String?,
        street: formData['street'] as String?,
        latitude: formData['latitude'] as String?,
        longitude: formData['longitude'] as String?,
        isDefault: false,
      );

      await notifier.addAddress(newAddress);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address added successfully'.i18n),
            backgroundColor: colorScheme.primary,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add address: ${e.toString()}'.i18n),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final form = ref.watch(addressFormProvider);
    final isValid = ref.watch(addressFormIsValidProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Address'.i18n),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveAddress,
            child: Text(
              'Save'.i18n,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isSaving
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LocationMapWidget(
                onLocationSelected: _onLocationSelected,
                onCoordinatesChanged: _onCoordinatesChanged,
              ),
              const SizedBox(height: 20),

              ReactiveDropdownField<AddressType>(
                formControlName: 'type',
                decoration: InputDecoration(
                  labelText: 'Address Type'.i18n,
                  prefixIcon: const Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: AddressType.home,
                    child: Text('Home'.i18n),
                  ),
                  DropdownMenuItem(
                    value: AddressType.office,
                    child: Text('Office'.i18n),
                  ),
                  DropdownMenuItem(
                    value: AddressType.other,
                    child: Text('Other'.i18n),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ReactiveTextField<String>(
                formControlName: 'label',
                decoration: InputDecoration(
                  labelText: 'Address Label'.i18n,
                  hintText: 'e.g., Home, Office, etc.'.i18n,
                  prefixIcon: const Icon(Icons.home_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Label is required'.i18n,
                },
              ),
              const SizedBox(height: 16),

              ReactiveTextField<String>(
                formControlName: 'fullAddress',
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Full Address'.i18n,
                  hintText: 'Street, building, apartment number...'.i18n,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Address is required'.i18n,
                },
              ),
              const SizedBox(height: 16),

              ReactiveTextField<String>(
                formControlName: 'city',
                decoration: InputDecoration(
                  labelText: 'City'.i18n,
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ReactiveTextField<String>(
                formControlName: 'street',
                decoration: InputDecoration(
                  labelText: 'Street'.i18n,
                  prefixIcon: const Icon(Icons.streetview),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ReactiveTextField<String>(
                      formControlName: 'latitude',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Latitude'.i18n,
                        prefixIcon: const Icon(Icons.my_location),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReactiveTextField<String>(
                      formControlName: 'longitude',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Longitude'.i18n,
                        prefixIcon: const Icon(Icons.my_location),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
