import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';
import '../../domain/models/category_model.dart';

class ProfessionChipGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final String formControlName;

  const ProfessionChipGrid({
    super.key,
    required this.categories,
    required this.formControlName,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder<String>(
      formControlName: formControlName,
      builder: (context, control, child) {
        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: categories.map((category) {
            final isSelected = control.value == category.id;
            return ChoiceChip(
              label: Text(category.name.i18n),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  control.value = category.id;
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}
