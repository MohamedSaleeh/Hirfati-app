import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../providers/profile_setup_controller.dart';
import '../widgets/city_dropdown_field.dart';
import '../widgets/location_map_widget.dart';
import '../widgets/profile_avatar_picker.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'city': FormControl<String>(validators: [Validators.required]),
      'latitude': FormControl<String>(),
      'longitude': FormControl<String>(),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _syncLocationToForm(double? lat, double? lng) {
    _form.control('latitude').value = lat != null ? lat.toStringAsFixed(4) : '';
    _form.control('longitude').value = lng != null
        ? lng.toStringAsFixed(4)
        : '';
  }

  Future<void> _onSave() async {
    _form.markAllAsTouched();
    if (!_form.valid) return;

    final success = await ref.read(profileSetupProvider.notifier).submit();
    if (success && mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileAsync = ref.watch(profileSetupProvider);

    ref.listen(profileSetupProvider, (_, next) {
      final val = next.asData?.value;
      if (val != null) {
        _syncLocationToForm(val.latitude, val.longitude);
      }
    });

    final profileState = profileAsync.asData?.value;
    final isLoading = profileState?.isLoading ?? false;
    final errorMessage = profileState?.errorMessage;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Complete Your Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              final controller = ref.read(profileSetupProvider.notifier);
              await controller.skipOnboarding();
              if (mounted && context.mounted) {
                context.go('/');
              }
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: ProfileAvatarPicker()),
              const SizedBox(height: 32),
              const CityDropdownField(),
              const SizedBox(height: 24),
              const LocationMapWidget(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildReadonlyField(
                      label: 'Latitude',
                      formControlName: 'latitude',
                      icon: Icons.explore_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildReadonlyField(
                      label: 'Longitude',
                      formControlName: 'longitude',
                      icon: Icons.explore_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: colorScheme.error, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 8),
              _buildSaveButton(isLoading),
              const SizedBox(height: 16),
              Text(
                'You can edit this information later in settings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadonlyField({
    required String label,
    required String formControlName,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        ReactiveTextField<String>(
          formControlName: formControlName,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: '—',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
          ),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.38),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : _onSave,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save and Continue',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}