import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../translations.dart';
import '../../domain/models/worker_order.dart';
import '../widgets/order_details/order_service_card.dart';
import '../widgets/order_details/order_client_card.dart';
import '../widgets/order_details/order_location_card.dart';
import '../widgets/order_details/order_schedule_card.dart';
import '../widgets/order_details/order_status_card.dart';
import '../widgets/order_details/order_action_buttons.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final WorkerOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text('order_details'.i18n),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderServiceCard(order: order),
            const SizedBox(height: 16),
            OrderClientCard(order: order),
            const SizedBox(height: 16),
            OrderLocationCard(order: order),
            const SizedBox(height: 16),
            OrderScheduleCard(order: order),
            const SizedBox(height: 16),
            OrderStatusCard(order: order),
            const SizedBox(height: 24),
            OrderActionButtons(order: order),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
