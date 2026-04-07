import 'package:flutter/material.dart';
import '../../../../../../translations.dart';

class WithdrawBankDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> banks;
  final String? selectedBank;
  final ValueChanged<String> onBankSelected;

  const WithdrawBankDropdown({
    super.key,
    required this.banks,
    required this.selectedBank,
    required this.onBankSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBank?.isEmpty ?? true ? null : selectedBank,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'select_bank'.i18n.replaceAll('_', ' '),
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
          items: banks.map((bank) {
            return DropdownMenuItem(
              value: bank['name'] as String,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(bank['color']).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      bank['icon'],
                      color: Color(bank['color']),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(bank['name']),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onBankSelected(value);
          },
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
