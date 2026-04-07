import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../providers/client_profile_provider.dart';
import '../providers/edit_profile_formgroup_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late FormGroup _form;
  bool _isSaving = false;

  Future<void> _saveChanges() async {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(clientProfileProvider.notifier);
      final fullName = _form.control('fullName').value as String?;
      final phoneNumber = _form.control('phoneNumber').value as String?;

      await notifier.updateProfile(
        fullName: fullName?.trim(),
        phoneNumber: phoneNumber?.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'.i18n),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'.i18n),
            backgroundColor: Theme.of(context).colorScheme.error,
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
    _form = ref.watch(editProfileFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'.i18n),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: Text(
              'Save'.i18n,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isSaving
                    ? theme.colorScheme.outline
                    : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'fullName',
                decoration: InputDecoration(
                  labelText: 'Full Name'.i18n,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Name is required'.i18n,
                },
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'phoneNumber',
                decoration: InputDecoration(
                  labelText: 'Phone Number'.i18n,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                keyboardType: TextInputType.phone,
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      'Phone number is required'.i18n,
                  ValidationMessage.pattern: (_) =>
                      'Please enter a valid phone number'.i18n,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
