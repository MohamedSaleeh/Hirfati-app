import 'package:flutter/material.dart';
import '../../../../../translations.dart';
import '../../domain/models/work_category_model.dart';

class CategoryFilterChips extends StatelessWidget {
  final List<WorkCategoryModel> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // All chip
          FilterChip(
            label: Text('all'.i18n),
            selected: selectedCategory == null,
            onSelected: (_) => onCategorySelected(null),
            backgroundColor: Colors.grey.shade100,
            selectedColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            labelStyle: TextStyle(
              color: selectedCategory == null
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
              fontWeight: selectedCategory == null
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          // Category chips
          ...categories.map((category) {
            final isSelected = selectedCategory == category.name;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category.name.i18n),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(category.name),
                backgroundColor: Colors.grey.shade100,
                selectedColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
