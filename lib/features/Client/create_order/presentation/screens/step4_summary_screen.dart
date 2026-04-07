import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/image_utils.dart';
import '../../../../../translations.dart';
import '../providers/create_order_provider.dart';

class Step4SummaryScreen extends ConsumerWidget {
  const Step4SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final order = ref.watch(createOrderProvider).order;

    return ListView(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      children: [
        Text(
          'Review Request Summary'.i18n,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        Card(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(Icons.build, color: colorScheme.primary),
            title: Text(
              order.categoryName.i18n,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: Text(
              order.description,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),

        Card(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(Icons.location_on, color: colorScheme.primary),
            title: Text(
              'Address'.i18n,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: Text(
              order.address ?? '-',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),

        Card(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(Icons.access_time, color: colorScheme.primary),
            title: Text(
              'Preferred time slot'.i18n,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: Text(
              _getTimeSlotDisplay(order.preferredTimeSlot),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),

        if (order.accessInstructions.trim().isNotEmpty)
          Card(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(Icons.info_outline, color: colorScheme.primary),
              title: Text(
                'Access Instructions'.i18n,
                style: TextStyle(color: colorScheme.onSurface),
              ),
              subtitle: Text(
                order.accessInstructions,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),

        if (order.photos.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Photos'.i18n,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: order.photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final photo = order.photos[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageUtils.buildPreview(
                    photo.localPath,
                    width: 88,
                    height: 88,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  String _getTimeSlotDisplay(String slot) {
    switch (slot) {
      case 'morning':
        return 'Morning (8:00 - 12:00)'.i18n;
      case 'afternoon':
        return 'Afternoon (12:00 - 17:00)'.i18n;
      case 'evening':
        return 'Evening (17:00 - 20:00)'.i18n;
      default:
        return slot.i18n;
    }
  }
}
