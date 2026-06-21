import 'package:flutter/material.dart';
import '../../../../../translations.dart';

class EarningsStatsCard extends StatelessWidget {
  final double thisWeekEarnings;
  final double weeklyChangePercent;
  final int totalOrders;
  final int completedOrders;

  const EarningsStatsCard({
    super.key,
    required this.thisWeekEarnings,
    required this.weeklyChangePercent,
    required this.totalOrders,
    required this.completedOrders,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = weeklyChangePercent >= 0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'this_week_earnings'.i18n,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${thisWeekEarnings.toStringAsFixed(0)} \$',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isPositive
                          ? colorScheme.tertiary
                          : colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${weeklyChangePercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: isPositive
                            ? colorScheme.tertiary
                            : colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(width: 1, height: 50, color: colorScheme.outlineVariant),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'completed_orders'.i18n,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completedOrders / $totalOrders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
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
