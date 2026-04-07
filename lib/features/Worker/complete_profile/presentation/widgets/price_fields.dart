import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';

class PriceFields extends StatelessWidget {
  final String minControlName;
  final String maxControlName;

  const PriceFields({
    super.key,
    required this.minControlName,
    required this.maxControlName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ReactiveTextField<double>(
            formControlName: minControlName,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Min Price'.i18n,
              prefixIcon: const Icon(Icons.attach_money),
              border: const OutlineInputBorder(),
            ),
            validationMessages: {
              ValidationMessage.required: (error) => 'Required'.i18n,
              ValidationMessage.min: (error) => 'Invalid'.i18n,
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ReactiveTextField<double>(
            formControlName: maxControlName,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Max Price'.i18n,
              prefixIcon: const Icon(Icons.money_off),
              border: const OutlineInputBorder(),
            ),
            validationMessages: {
              ValidationMessage.required: (error) => 'Required'.i18n,
              'minLessThanMax': (error) => 'Must be > Min'.i18n,
            },
          ),
        ),
      ],
    );
  }
}
