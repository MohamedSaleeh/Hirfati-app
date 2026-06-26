import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/presentation/providers/language_provider.dart';
import '../../../../../translations.dart';
import '../../domain_models/category_model.dart';
import 'category_item_widget.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final bool showAll;
  final VoidCallback? onSeeAll;
  final ValueChanged<CategoryModel>? onCategoryTap;
  final WidgetRef? ref;
  CategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.showAll = false,
    this.onSeeAll,
    this.onCategoryTap,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayCategories = categories.isNotEmpty
        ? categories
        : _fallbackCategories;

    final categoriesToShow = showAll
        ? displayCategories
        : displayCategories.take(6).toList();

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

        if (showAll)
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

  late final language = ref!.read(language_provider.notifier).state;
  late final List _fallbackCategories = [
    if (language == "en")
      {
        const CategoryModel(id: '1', name: 'Plumbing', icon: 'plumbing'),
        const CategoryModel(id: '2', name: 'Electric', icon: 'electric'),
        const CategoryModel(id: '3', name: 'Wood', icon: 'wood'),
        const CategoryModel(id: '4', name: 'Paint', icon: 'paint'),
        const CategoryModel(id: '5', name: 'Cleaning', icon: 'cleaning'),
        const CategoryModel(id: '6', name: 'AC Repair', icon: 'ac'),
        const CategoryModel(id: '7', name: 'Carpentry', icon: 'carpentry'),
        const CategoryModel(id: '8', name: 'Blacksmith', icon: 'blacksmith'),
        const CategoryModel(id: '9', name: 'Air Conditioning', icon: 'ac'),
      }
    else
      {
        const CategoryModel(id: '1', name: 'سباكة', icon: 'plumbing'),
        const CategoryModel(id: '2', name: 'الكهرباء', icon: 'Electrical'),
        const CategoryModel(id: '3', name: 'الخشب', icon: 'wood'),
        const CategoryModel(id: '4', name: 'الدهان', icon: 'paint'),
        const CategoryModel(id: '5', name: 'التنظيف', icon: 'cleaning'),
        const CategoryModel(id: '6', name: 'إصلاح مكيفات', icon: 'ac'),
        const CategoryModel(id: '7', name: 'النجارة', icon: 'carpentry'),
        const CategoryModel(id: '8', name: 'الحدادة', icon: 'blacksmith'),
        const CategoryModel(id: '9', name: 'تكييف الهواء', icon: 'ac'),
      },
  ];
}
