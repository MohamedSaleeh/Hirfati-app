import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../translations.dart';
import '../../domain/models/address_model.dart';
import '../providers/address_formgroup_provider.dart';
import '../providers/addresses_provider.dart';
import '../widgets/location_map_widget.dart';

class EditAddressScreen extends ConsumerStatefulWidget {
  final AddressModel address;

  const EditAddressScreen({super.key, required this.address});

  @override
  ConsumerState<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends ConsumerState<EditAddressScreen> {
  bool _isSaving = false;
  bool _isFormReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedAddressProvider.notifier).state = widget.address;
      setState(() {
        _isFormReady = true;
      });
    });
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

      if (widget.address.id == null) {
        throw Exception('Address ID is missing');
      }

      final updatedAddress = widget.address.copyWith(
        label: formData['label'] as String,
        addressType: formData['type'] as AddressType,
        fullAddress: formData['fullAddress'] as String,
        city: formData['city'] as String?,
        street: formData['street'] as String?,
        latitude: formData['latitude'] as String?,
        longitude: formData['longitude'] as String?,
      );

      await notifier.updateAddress(updatedAddress);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address updated successfully'.i18n),
            backgroundColor: colorScheme.primary,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update address: ${e.toString()}'.i18n),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteAddress() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final addressId = widget.address.id;

    if (addressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot delete address: ID is missing'.i18n),
          backgroundColor: colorScheme.error,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'.i18n),
        content: Text('Are you sure you want to delete this address?'.i18n),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'.i18n),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: Text('Delete'.i18n),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isSaving = true);
      try {
        final notifier = ref.read(addressesProvider.notifier);
        await notifier.deleteAddress(addressId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Address deleted successfully'.i18n),
              backgroundColor: colorScheme.primary,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete address: ${e.toString()}'.i18n),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!_isFormReady) {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
      );
    }

    FormGroup? form;
    try {
      form = ref.watch(addressFormProvider);
    } catch (e) {
      form = FormGroup({});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Address'.i18n),
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
        formGroup: form!,
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
                      decoration: InputDecoration(
                        labelText: 'Latitude'.i18n,
                        prefixIcon: const Icon(Icons.my_location),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReactiveTextField<String>(
                      formControlName: 'longitude',
                      decoration: InputDecoration(
                        labelText: 'Longitude'.i18n,
                        prefixIcon: const Icon(Icons.my_location),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isSaving ? null : _deleteAddress,
                  icon: const Icon(Icons.delete_outline),
                  label: Text('Delete Address'.i18n),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
