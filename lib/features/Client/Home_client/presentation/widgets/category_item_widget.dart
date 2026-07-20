import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/providers/language_provider.dart';
import '../../domain_models/category_model.dart';

IconData _iconForCategory(String? icon, String name) {
  final key = (icon ?? name).toLowerCase();
  if (key.contains('plumb') || key.contains('water')) {
    return Icons.water_drop_outlined;
  }
  if (key.contains('electric') || key.contains('power')) {
    return Icons.bolt_outlined;
  }
  if (key.contains('wood') || key.contains('carpent')) {
    return Icons.carpenter_outlined;
  }
  if (key.contains('paint')) {
    return Icons.format_paint_outlined;
  }
  if (key.contains('clean')) {
    return Icons.cleaning_services_outlined;
  }
  if (key.contains('ac') || key.contains('air') || key.contains('cool')) {
    return Icons.ac_unit_outlined;
  }
  if (key.contains('lock') || key.contains('security')) {
    return Icons.lock_outline_rounded;
  }
  if (key.contains('garden') || key.contains('plant')) {
    return Icons.park_outlined;
  }
  return Icons.handyman_outlined;
}

class CategoryItemWidget extends ConsumerWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryItemWidget({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final language = ref.watch(language_provider);
    final displayName = resolveCategoryDisplayName(category, language);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _iconForCategory(category.icon, category.name),
              color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
