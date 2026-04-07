import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../../translations.dart';
import '../../../../Client/completeProfile/presentation/providers/profile_setup_controller.dart';
import '../../../../Client/completeProfile/presentation/widgets/location_map_widget.dart';
import '../../domain/models/worker_profile_model.dart';
import '../providers/complete_worker_profile_provider.dart';
import '../widgets/availability_switch.dart';
import '../widgets/experience_field.dart';
import '../widgets/price_fields.dart';
import '../widgets/profession_chip.dart';
import '../widgets/sham_cash_code_field.dart';

class CompleteProfessionalProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfessionalProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfessionalProfileScreen> createState() =>
      _CompleteProfessionalProfileScreenState();
}

class _CompleteProfessionalProfileScreenState
    extends ConsumerState<CompleteProfessionalProfileScreen> {
  late FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup(
      {
        'categoryId': FormControl<String>(validators: [Validators.required]),
        'experienceYears': FormControl<int>(
          validators: [Validators.required, Validators.min(0)],
        ),
        'bio': FormControl<String>(
          validators: [Validators.required, Validators.minLength(20)],
        ),
        'priceMin': FormControl<double>(
          validators: [Validators.required, Validators.min(0)],
        ),
        'priceMax': FormControl<double>(validators: [Validators.required]),
        'isAvailable': FormControl<bool>(value: true),
        'shamCashCode': FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(20),
            Validators.pattern(r'^[A-Z0-9]{6,20}$'),
          ],
        ),
      },
      validators: [Validators.delegate(_priceComparisonValidator)],
    );
  }

  Map<String, dynamic>? _priceComparisonValidator(
    AbstractControl<dynamic> control,
  ) {
    if (control is! FormGroup) return null;
    final minControl = control.control('priceMin');
    final maxControl = control.control('priceMax');

    final minVal = minControl.value as double?;
    final maxVal = maxControl.value as double?;

    if (minVal != null && maxVal != null && minVal > maxVal) {
      maxControl.setErrors({'minLessThanMax': true});
      maxControl.markAsTouched();
    } else {
      maxControl.removeError('minLessThanMax');
    }
    return null;
  }

  Future<void> _submitForm() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_form.invalid) {
      _form.markAllAsTouched();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fix the errors in the form.'.i18n),
          backgroundColor: colorScheme.error,
        ),
      );
      return;
    }

    final profileState = ref.read(profileSetupProvider);
    final lat = profileState.value!.latitude;
    final lng = profileState.value!.longitude;

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select your service area on the map'.i18n),
          backgroundColor: colorScheme.error,
        ),
      );
      return;
    }

    final data = _form.value;
    final profile = WorkerProfileModel(
      categoryId: data['categoryId'] as String,
      experienceYears: data['experienceYears'] as int,
      bio: data['bio'] as String,
      priceMin: data['priceMin'] as double,
      priceMax: data['priceMax'] as double,
      isAvailable: data['isAvailable'] as bool? ?? true,
      latitude: lat,
      longitude: lng,
      shamCashCode: data['shamCashCode'] as String,
    );

    final success = await ref
        .read(completeWorkerProfileProvider.notifier)
        .submitProfile(profile);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile submitted successfully!'.i18n),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/worker');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit profile. Please try again.'.i18n),
          backgroundColor: colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoriesAsync = ref.watch(workerCategoriesProvider);
    final submitState = ref.watch(completeWorkerProfileProvider);
    final isSubmitting = submitState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Professional Profile'.i18n,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface,
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.primaryContainer),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pending_actions, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your profile will be placed Under Review after submission.'
                            .i18n,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Select Your Profession'.i18n,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              categoriesAsync.when(
                data: (categories) {
                  return ProfessionChipGrid(
                    categories: categories,
                    formControlName: 'categoryId',
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (error, stack) => Text(
                  'Failed to load categories: $error'.i18n,
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
              const SizedBox(height: 24),

              const ExperienceField(formControlName: 'experienceYears'),
              const SizedBox(height: 16),

              ReactiveTextField<String>(
                formControlName: 'bio',
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Professional Bio'.i18n,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                  hintText: 'Tell clients about your expertise and skills'.i18n,
                ),
                validationMessages: {
                  ValidationMessage.required: (error) => 'Required'.i18n,
                  ValidationMessage.minLength: (error) =>
                      'Bio must be at least 20 characters'.i18n,
                },
              ),
              const SizedBox(height: 16),

              const ShamCashCodeField(formControlName: 'shamCashCode'),
              const SizedBox(height: 16),

              const PriceFields(
                minControlName: 'priceMin',
                maxControlName: 'priceMax',
              ),
              const SizedBox(height: 24),

              const AvailabilitySwitch(formControlName: 'isAvailable'),
              const SizedBox(height: 24),

              const LocationMapWidget(),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Submit for Review'.i18n,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
