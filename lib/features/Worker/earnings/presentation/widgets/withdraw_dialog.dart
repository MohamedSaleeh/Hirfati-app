import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../providers/earnings_provider.dart';

class WithdrawDialog extends ConsumerStatefulWidget {
  final double availableBalance;

  const WithdrawDialog({super.key, required this.availableBalance});

  @override
  ConsumerState<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends ConsumerState<WithdrawDialog> {
  late FormGroup _form;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'amount': FormControl<double>(
        validators: [
          Validators.required,
          Validators.min(100),
          Validators.max(widget.availableBalance),
        ],
      ),
      'bankName': FormControl<String>(validators: [Validators.required]),
      'accountNumber': FormControl<String>(validators: [Validators.required]),
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
      final notifier = ref.read(earningsProvider.notifier);
      await notifier.requestWithdrawal(
        amount: _form.control('amount').value as double,
        bankName: _form.control('bankName').value as String,
        accountNumber: _form.control('accountNumber').value as String,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Withdrawal request submitted successfully'.i18n),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'.i18n),
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
    final colorScheme = theme.colorScheme;
    return AlertDialog(
      title: Text('request_withdrawal'.i18n),
      content: SingleChildScrollView(
        child: ReactiveForm(
          formGroup: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Amount
              ReactiveTextField<double>(
                formControlName: 'amount',
                decoration: InputDecoration(
                  labelText: 'amount'.i18n,
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                valueAccessor: _DoubleValueAccessor(),
                validationMessages: {
                  ValidationMessage.required: (_) => 'amount_required'.i18n,
                  ValidationMessage.min: (_) => 'amount_min'.i18n,
                  ValidationMessage.max: (_) => 'amount_max'.i18n,
                },
              ),
              const SizedBox(height: 16),
              // Bank Name
              ReactiveTextField<String>(
                formControlName: 'bankName',
                decoration: InputDecoration(
                  labelText: 'bank_name'.i18n,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'bank_name_required'.i18n,
                },
              ),
              const SizedBox(height: 16),
              // Account Number
              ReactiveTextField<String>(
                formControlName: 'accountNumber',
                decoration: InputDecoration(
                  labelText: 'account_number'.i18n,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      'account_number_required'.i18n,
                },
              ),
              const SizedBox(height: 8),
              Text(
                'withdraw_notice'.i18n,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.i18n),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('submit'.i18n),
        ),
      ],
    );
  }
}

class _DoubleValueAccessor extends ControlValueAccessor<double, String> {
  @override
  String modelToViewValue(double? modelValue) => modelValue?.toString() ?? '';

  @override
  double? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) return null;
    return double.tryParse(viewValue);
  }
}
