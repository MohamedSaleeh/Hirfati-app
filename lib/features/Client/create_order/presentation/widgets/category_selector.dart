import 'package:flutter/material.dart';

import '../../../../../translations.dart';
import '../../../Home_client/domain_models/category_model.dart';

class CategorySelector extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategoryId;
  final ValueChanged<CategoryModel> onSelect;
  final bool enabled;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelect,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories
          .map(
            (cat) => ChoiceChip(
              label: Text(
                cat.name.i18n,
                style: TextStyle(
                  color: selectedCategoryId == cat.id
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
              selected: selectedCategoryId == cat.id,
              onSelected: enabled ? (_) => onSelect(cat) : null,
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest,
              side: BorderSide(
                color: selectedCategoryId == cat.id
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
            ),
          )
          .toList(),
    );
  }
}
