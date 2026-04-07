import 'package:flutter/material.dart';
import '../../../../../translations.dart';
import '../../domain/models/worker_profile_portfolio_model.dart';

class WorkerPortfolioPreview extends StatelessWidget {
  final List<WorkerProfilePortfolioModel> items;
  final VoidCallback onViewAll;

  const WorkerPortfolioPreview({
    super.key,
    required this.items,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Text(
        'No portfolio items yet'.i18n,
        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Portfolio'.i18n, onViewAll: onViewAll),
        const SizedBox(height: 10),
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            final imageUrl = item.imageUrls.isNotEmpty
                ? item.imageUrls.first
                : null;

            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: imageUrl == null
                    ? Icon(
                        Icons.image_not_supported,
                        color: theme.colorScheme.onSurfaceVariant,
                      )
                    : Image.network(imageUrl, fit: BoxFit.cover),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            'View All'.i18n,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
