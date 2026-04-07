import 'package:flutter/material.dart';
import '../../../../../../core/models/order.dart';
import '../../../../../../translations.dart';
import '../../../domain/models/worker_order.dart';

class OrderScheduleCard extends StatelessWidget {
  final WorkerOrder order;

  const OrderScheduleCard({super.key, required this.order});

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'schedule_details'.i18n.replaceAll('_', ' '),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (order.requestType == OrderRequestType.immediate)
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'immediate_request'.i18n.replaceAll('_', ' '),
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            )
          else if (order.scheduledAt != null)
            Text(
              _formatDateTime(order.scheduledAt!),
              style: const TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }
}
