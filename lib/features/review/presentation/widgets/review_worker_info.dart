import 'package:flutter/material.dart';
import 'package:hirfati/translations.dart';
import '../../../../core/models/order.dart';

class ReviewWorkerInfo extends StatelessWidget {
  final Order order;

  const ReviewWorkerInfo({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: order.workerAvatarUrl != null
                ? NetworkImage(order.workerAvatarUrl!)
                : null,
            child: order.workerAvatarUrl == null
                ? Text(
                    order.workerName[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.colorScheme.onSurface,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.workerName.i18n,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.serviceTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
