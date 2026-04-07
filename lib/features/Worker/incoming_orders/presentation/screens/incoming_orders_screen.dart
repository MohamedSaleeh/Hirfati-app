import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../../translations.dart';
import '../../../worker_home/presentation/providers/active_jobs_provider.dart';
import '../providers/incoming_orders_provider.dart';
import '../widgets/incoming_order_card.dart';
import '../widgets/empty_incoming_orders.dart';

class IncomingOrdersScreen extends ConsumerWidget {
  const IncomingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ordersAsync = ref.watch(incomingOrdersProvider);
    final notifier = ref.read(incomingOrdersProvider.notifier);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(
          'incoming orders'.i18n,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.loadOrders(),
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const EmptyIncomingOrders();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return IncomingOrderCard(
                  order: order,
                  onAccept: () async {
                    try {
                      await notifier.acceptOrder(order.id);
                      ref.invalidate(activeJobsProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'order_accepted'.i18n.replaceAll('_', ' '),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'error_accepting_order'.i18n.replaceAll('_', ' '),
                            ),
                            backgroundColor: colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                  onReject: () async {
                    try {
                      await notifier.rejectOrder(order.id);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'error_rejecting_order'.i18n.replaceAll('_', ' '),
                            ),
                            backgroundColor: colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            );
          },
          loading: () => Center(
            child: Lottie.asset(
              'assets/animations/loading_animation.json',
              width: 150,
              height: 150,
              repeat: true,
            ),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'error_loading_orders'.i18n.replaceAll('_', ' '),
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => notifier.loadOrders(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Text('retry'.i18n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
