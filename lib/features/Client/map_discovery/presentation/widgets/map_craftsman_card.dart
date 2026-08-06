import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/providers/language_provider.dart';
import '../../../../../translations.dart';
import '../../../Home_client/domain_models/category_model.dart';
import '../../../Home_client/domain_models/craftsman_model.dart';

class MapCraftsmanCard extends ConsumerWidget {
  final CraftsmanModel craftsman;
  final bool isSelected;

  const MapCraftsmanCard({
    super.key,
    required this.craftsman,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final language = ref.watch(language_provider);
    final professionLabel = craftsman.category == null
        ? craftsman.profession ?? ''
        : resolveCategoryDisplayName(craftsman.category!, language);
    final displayProfession = professionLabel.isEmpty
        ? 'Professional'.i18n
        : professionLabel;
    final distanceText = craftsman.distance > 0
        ? '${craftsman.distance.toStringAsFixed(1)} km away'.i18n
        : '1.2 km away'.i18n;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16, bottom: 20, top: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(isSelected ? 0.1 : 0.05),
            blurRadius: isSelected ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.push('/client/workers/${craftsman.id}'),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    image:
                        (craftsman.avatarUrl != null &&
                            craftsman.avatarUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(craftsman.avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child:
                      (craftsman.avatarUrl == null ||
                          craftsman.avatarUrl!.isEmpty)
                      ? Icon(
                          Icons.person,
                          size: 28,
                          color: colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          context.push('/client/workers/${craftsman.id}'),
                      child: Text(
                        craftsman.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayProfession,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          craftsman.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          ' (124)',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    distanceText,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _handleBooking(context, professionLabel),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Book'.i18n,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBooking(BuildContext context, String professionLabel) {
    context.push(
      '/create-order',
      extra: {
        'workerId': craftsman.id,
        'serviceId': craftsman.serviceId ?? '',
        'serviceName': professionLabel,
        'estimatedPrice': craftsman.hourlyPrice,
        'isDirectBooking': true,
      },
    );
  }
}
