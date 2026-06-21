import 'package:flutter/material.dart';
import '../../../../../../core/models/order.dart';
import '../../../../../../translations.dart';
import '../../../domain/models/worker_order.dart';

class OrderStatusCard extends StatelessWidget {
  final WorkerOrder order;

  const OrderStatusCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'pending'.i18n;
        break;
      case OrderStatus.accepted:
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle;
        statusText = 'accepted'.i18n;
        break;
      case OrderStatus.in_progress:
        statusColor = Colors.green;
        statusIcon = Icons.build;
        statusText = 'in_progress'.i18n;
        break;
      case OrderStatus.completed:
        statusColor = Colors.grey;
        statusIcon = Icons.done_all;
        statusText = 'completed'.i18n;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'unknown'.i18n;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'current_status'.i18n,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
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
