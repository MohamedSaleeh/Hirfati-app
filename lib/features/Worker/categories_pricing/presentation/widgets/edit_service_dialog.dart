import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../../domain/models/worker_service_model.dart';
import '../providers/categories_pricing_provider.dart';

class EditServiceDialog extends ConsumerStatefulWidget {
  final WorkerServiceModel service;

  const EditServiceDialog({super.key, required this.service});

  @override
  ConsumerState<EditServiceDialog> createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends ConsumerState<EditServiceDialog> {
  late FormGroup _form;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    _form = FormGroup({
      'title': FormControl<String>(
        value: service.title,
        validators: [Validators.required],
      ),
      'price': FormControl<double>(
        value: service.price,
        validators: [Validators.required, Validators.min(0)],
      ),
      'description': FormControl<String>(value: service.description),
      'durationMinutes': FormControl<int>(
        value: service.durationMinutes,
        validators: [Validators.min(0)],
      ),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(categoriesPricingProvider.notifier);

      final updatedService = widget.service.copyWith(
        title: _form.control('title').value as String,
        price: _form.control('price').value as double,
        description: _form.control('description').value as String?,
        durationMinutes: _form.control('durationMinutes').value as int?,
      );

      await notifier.updateService(updatedService);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'service_updated_successfully'.i18n.replaceAll('_', ' '),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_updating_service'.i18n.replaceAll('_', ' ')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'edit_service'.i18n.replaceAll('_', ' '),
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      content: SingleChildScrollView(
        child: ReactiveForm(
          formGroup: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactiveTextField<String>(
                formControlName: 'title',
                decoration: InputDecoration(
                  labelText: 'service_title'.i18n,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  hintText: 'e.g., AC Installation',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
                validationMessages: {
                  ValidationMessage.required: (_) => 'title_required'.i18n,
                },
              ),
              const SizedBox(height: 16),

              ReactiveTextField<double>(
                formControlName: 'price',
                decoration: InputDecoration(
                  labelText: 'service_price'.i18n,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  prefixText: '\$ ',
                  hintText: 'e.g., 150',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                valueAccessor: _DoubleValueAccessor(),
                style: TextStyle(color: theme.colorScheme.onSurface),
                validationMessages: {
                  ValidationMessage.required: (_) => 'price_required'.i18n,
                  ValidationMessage.min: (_) => 'price_min_error'.i18n,
                },
              ),
              const SizedBox(height: 16),

              ReactiveTextField<int>(
                formControlName: 'durationMinutes',
                decoration: InputDecoration(
                  labelText: 'duration_minutes'.i18n,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  hintText: 'e.g., 60',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                valueAccessor: _IntValueAccessor(),
                style: TextStyle(color: theme.colorScheme.onSurface),
                validationMessages: {
                  ValidationMessage.min: (_) => 'duration_min_error'.i18n,
                },
              ),
              const SizedBox(height: 16),

              ReactiveTextField<String>(
                formControlName: 'description',
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'service_description'.i18n,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  hintText: 'tell_about_service'.i18n,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'cancel'.i18n,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
          ),
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(
                  'save'.i18n,
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
        ),
      ],
    );
  }
}

class _DoubleValueAccessor extends ControlValueAccessor<double, String> {
  @override
  String modelToViewValue(double? modelValue) {
    return modelValue?.toString() ?? '';
  }

  @override
  double? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) return null;
    return double.tryParse(viewValue);
  }
}

class _IntValueAccessor extends ControlValueAccessor<int, String> {
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
