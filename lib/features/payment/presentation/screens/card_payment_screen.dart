// lib/features/payment/presentation/screens/card_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../translations.dart';

class CardPaymentScreen extends ConsumerStatefulWidget {
  final double amount;

  const CardPaymentScreen({super.key, required this.amount});

  @override
  ConsumerState<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends ConsumerState<CardPaymentScreen> {
  late FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'cardHolder': FormControl<String>(validators: [Validators.required]),
      'cardNumber': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(16),
          Validators.maxLength(16),
          Validators.pattern(r'^[0-9]{16}$'),
        ],
      ),
      'expiry': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^(0[1-9]|1[0-2])\/[0-9]{2}$'),
        ],
      ),
      'cvv': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(3),
          Validators.maxLength(3),
          Validators.pattern(r'^[0-9]{3}$'),
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay with Credit Card'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount:'.i18n,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${widget.amount} \$',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ReactiveTextField(
                formControlName: 'cardHolder',
                decoration: InputDecoration(
                  labelText: 'Card Holder Name'.i18n,
                  prefixIcon: Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                  ),
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              ReactiveTextField(
                formControlName: 'cardNumber',
                decoration: InputDecoration(
                  labelText: 'Card Number'.i18n,
                  prefixIcon: Icon(
                    Icons.credit_card,
                    color: theme.colorScheme.primary,
                  ),
                  border: const OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ReactiveTextField(
                      formControlName: 'expiry',
                      decoration: InputDecoration(
                        labelText: 'MM/YY'.i18n,
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: theme.colorScheme.primary,
                        ),
                        border: const OutlineInputBorder(),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.datetime,
                      maxLength: 5,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ReactiveTextField(
                      formControlName: 'cvv',
                      decoration: InputDecoration(
                        labelText: 'CVV'.i18n,
                        prefixIcon: Icon(
                          Icons.security,
                          color: theme.colorScheme.primary,
                        ),
                        border: const OutlineInputBorder(),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Consumer(
                builder: (context, ref, child) {
                  final isValid = _form.valid;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isValid ? _submitPayment : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isValid
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: Text('Submit Payment'.i18n),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPayment() {
    if (_form.valid) {
      final cardHolder = _form.control('cardHolder').value as String? ?? '';
      final cardNumber = _form.control('cardNumber').value as String? ?? '';
      final expiry = _form.control('expiry').value as String? ?? '';
      final cvv = _form.control('cvv').value as String? ?? '';

      Navigator.pop(context, {
        'cardHolder': cardHolder,
        'cardNumber': cardNumber,
        'expiry': expiry,
        'cvv': cvv,
      });
    }
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
}
