import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../../domain/models/payment_method_model.dart';
import '../providers/payment_methods_provider.dart';

class AddPaymentMethodScreen extends ConsumerStatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  ConsumerState<AddPaymentMethodScreen> createState() =>
      _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState
    extends ConsumerState<AddPaymentMethodScreen> {
  late FormGroup _form;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _form = FormGroup({
      'cardNumber': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^[0-9]{16}$')],
      ),
      'expiryMonth': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^(0[1-9]|1[0-2])$'),
        ],
      ),
      'expiryYear': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^[0-9]{2}$')],
      ),
      'cvv': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^[0-9]{3,4}$')],
      ),
      'cardholderName': FormControl<String>(validators: [Validators.required]),
      'saveCard': FormControl<bool>(value: true),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _savePaymentMethod() async {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(paymentMethodsProvider.notifier);

      final rawCardNumber = _form.control('cardNumber').value as String;
      final cardNumber = rawCardNumber.replaceAll(' ', '');

      final expiryMonth = _form.control('expiryMonth').value as String;
      final expiryYear = _form.control('expiryYear').value as String;
      final cardholderName = _form.control('cardholderName').value as String;

      final cardType = _detectCardType(cardNumber);
      final last4 = cardNumber.substring(cardNumber.length - 4);

      final newCard = PaymentMethodModel(
        id: '',
        cardType: cardType,
        last4: last4,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        isDefault: false,
        cardholderName: cardholderName,
      );

      await notifier.addPaymentMethod(newCard);

      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment method added successfully'.i18n),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add payment method: ${e.toString()}'.i18n),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  CardType _detectCardType(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(' ', '');

    if (cleanNumber.isEmpty) return CardType.visa;

    if (cleanNumber.startsWith('4')) {
      return CardType.visa;
    } else if (cleanNumber.startsWith('5')) {
      return CardType.mastercard;
    } else if (cleanNumber.startsWith('3')) {
      return CardType.amex;
    } else {
      return CardType.discover;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('Add Payment Method'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _savePaymentMethod,
            child: Text(
              'Save'.i18n,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isSaving
                    ? theme.colorScheme.onSurface.withOpacity(0.38)
                    : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardPreview(context),

              const SizedBox(height: 24),

              ReactiveTextField<String>(
                formControlName: 'cardNumber',
                decoration: InputDecoration(
                  labelText: 'Card Number'.i18n,
                  hintText: '1234 5678 9012 3456',
                  prefixIcon: Icon(
                    Icons.credit_card,
                    color: theme.colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: (value) {
                  setState(() {});
                },
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      'Card number is required'.i18n,
                  ValidationMessage.pattern: (_) => 'Invalid card number'.i18n,
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ReactiveTextField<String>(
                      formControlName: 'expiryMonth',
                      decoration: InputDecoration(
                        labelText: 'Expiry Month'.i18n,
                        hintText: 'MM',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: theme.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      validationMessages: {
                        ValidationMessage.required: (_) =>
                            'Month is required'.i18n,
                        ValidationMessage.pattern: (_) => 'Invalid month'.i18n,
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReactiveTextField<String>(
                      formControlName: 'expiryYear',
                      decoration: InputDecoration(
                        labelText: 'Expiry Year'.i18n,
                        hintText: 'YY',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: theme.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      validationMessages: {
                        ValidationMessage.required: (_) =>
                            'Year is required'.i18n,
                        ValidationMessage.pattern: (_) => 'Invalid year'.i18n,
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReactiveTextField<String>(
                      formControlName: 'cvv',
                      decoration: InputDecoration(
                        labelText: 'CVV'.i18n,
                        hintText: '123',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: theme.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validationMessages: {
                        ValidationMessage.required: (_) =>
                            'CVV is required'.i18n,
                        ValidationMessage.pattern: (_) => 'Invalid CVV'.i18n,
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ReactiveTextField<String>(
                formControlName: 'cardholderName',
                decoration: InputDecoration(
                  labelText: 'Cardholder Name'.i18n,
                  hintText: 'As shown on card',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      'Cardholder name is required'.i18n,
                },
              ),

              const SizedBox(height: 16),

              ReactiveCheckboxListTile(
                formControlName: 'saveCard',
                title: Text('Save card for future payments'.i18n),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.primary),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This is a demo. No real payment will be processed.',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPreview(BuildContext context) {
    final theme = Theme.of(context);
    final cardNumberRaw = _form.control('cardNumber').value as String? ?? '';
    final cardNumber = cardNumberRaw.replaceAll(' ', '');
    final expiryMonth = _form.control('expiryMonth').value as String? ?? '';
    final expiryYear = _form.control('expiryYear').value as String? ?? '';
    final cardholderName =
        _form.control('cardholderName').value as String? ?? 'YOUR NAME';

    final cardType = cardNumber.isNotEmpty
        ? _detectCardType(cardNumber)
        : CardType.visa;

    final String displayNumber;
    if (cardNumber.length >= 4) {
      displayNumber =
          '••••  ••••  ••••  ${cardNumber.substring(cardNumber.length - 4)}';
    } else {
      displayNumber = '••••  ••••  ••••  ••••';
    }

    final Color cardColor;
    if (cardType == CardType.visa) {
      cardColor = theme.colorScheme.primary;
    } else if (cardType == CardType.mastercard) {
      cardColor = theme.colorScheme.secondary;
    } else {
      cardColor = theme.colorScheme.tertiary;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor, cardColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardType.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Icon(Icons.credit_card, color: Colors.white.withOpacity(0.8)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Card Number'.i18n,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
            Text(
              displayNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPIRES'.i18n,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        expiryMonth.isNotEmpty && expiryYear.isNotEmpty
                            ? '$expiryMonth/$expiryYear'
                            : 'MM/YY',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'CARDHOLDER'.i18n,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        cardholderName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
