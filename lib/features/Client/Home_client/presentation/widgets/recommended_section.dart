import 'package:flutter/material.dart';
import '../../../../../translations.dart';
import '../../domain_models/craftsman_model.dart';
import 'craftsman_card_widget.dart';

class RecommendedSection extends StatelessWidget {
  final List<CraftsmanModel> craftsmen;
  final String? selectedCategoryId;
  final VoidCallback? onClearFilter;

  const RecommendedSection({
    super.key,
    required this.craftsmen,
    this.selectedCategoryId,
    this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasNoResults = selectedCategoryId != null && craftsmen.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCategoryId != null
                  ? 'Craftsmen'.i18n
                  : 'Recommended For You'.i18n,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            if (selectedCategoryId != null)
              TextButton(
                onPressed: onClearFilter,
                child: Text(
                  'Clear Filter'.i18n,
                  style: TextStyle(color: colorScheme.primary, fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (hasNoResults)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No craftsmen in this category'.i18n,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (craftsmen.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No craftsmen found'.i18n,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: craftsmen.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                CraftsmanCardWidget(craftsman: craftsmen[index]),
          ),
      ],
    );
  }
}
