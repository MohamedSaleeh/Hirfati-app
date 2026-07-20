import 'package:flutter/material.dart';
import '../../../../../translations.dart';
import '../../domain_models/category_model.dart';
import 'category_item_widget.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final bool showAll;
  final VoidCallback? onSeeAll;
  final ValueChanged<CategoryModel>? onCategoryTap;
  const CategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.showAll = false,
    this.onSeeAll,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categoriesToShow = showAll ? categories : categories.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories'.i18n,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            if (categories.isNotEmpty)
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  showAll ? 'Show Less'.i18n : 'See All'.i18n,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (categories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No categories found'.i18n,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else if (showAll)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categoriesToShow.length,
            itemBuilder: (context, index) {
              final cat = categoriesToShow[index];
              return CategoryItemWidget(
                category: cat,
                isSelected: selectedCategoryId == cat.id,
                onTap: () => onCategoryTap?.call(cat),
              );
            },
          )
        else
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesToShow.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final cat = categoriesToShow[index];
                return CategoryItemWidget(
                  category: cat,
                  isSelected: selectedCategoryId == cat.id,
                  onTap: () => onCategoryTap?.call(cat),
                );
              },
            ),
          ),
      ],
    );
  }
}
