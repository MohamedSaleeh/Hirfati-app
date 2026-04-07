import 'package:flutter/material.dart';

import '../../../../../translations.dart';

class TimeSlotSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const TimeSlotSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final slots = const ['morning', 'afternoon', 'evening'];

    return Wrap(
      spacing: 8,
      children: slots
          .map(
            (slot) => ChoiceChip(
              label: Text(
                slot.i18n,
                style: TextStyle(
                  color: selected == slot
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
              selected: selected == slot,
              onSelected: (_) => onChanged(slot),
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest,
              side: BorderSide(
                color: selected == slot
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
            ),
          )
          .toList(),
    );
  }
}
