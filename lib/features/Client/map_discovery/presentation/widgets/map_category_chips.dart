import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/presentation/providers/language_provider.dart';
import '../../../../../translations.dart';
import '../../../Home_client/domain_models/category_model.dart';
import '../providers/map_providers.dart';

class MapCategoryChips extends ConsumerWidget {
  const MapCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoriesAsync = ref.watch(mapCategoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryProvider);
    final language = ref.watch(language_provider);

    return categoriesAsync.when(
      data: (categories) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final category = isAll ? null : categories[index - 1];
              final isSelected = isAll
                  ? selectedCategoryId == null
                  : selectedCategoryId == category!.id;

              final labelText = isAll
                  ? 'All'.i18n
                  : resolveCategoryDisplayName(category!, language);

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state = isAll
                        ? null
                        : category!.id;
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      labelText,
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: 40,
        child: Center(
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
      ),
      error: (_, _) => const SizedBox(height: 40),
    );
  }
}
