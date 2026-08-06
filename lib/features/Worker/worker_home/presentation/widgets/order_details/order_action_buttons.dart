import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/models/order.dart';
import '../../../../../../translations.dart';
import '../../../../../../features/payment/presentation/widgets/payment_dialog.dart';
import '../../../domain/models/worker_order.dart';
import '../../providers/incoming_orders_provider.dart';

class OrderActionButtons extends ConsumerWidget {
  final WorkerOrder order;

  const OrderActionButtons({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAccepted = order.status == OrderStatus.accepted;
    final isInProgress = order.status == OrderStatus.in_progress;

    if (!isAccepted && !isInProgress) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (isAccepted)
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final actions = ref.read(incomingOrdersActionsProvider);
                  await actions.startOrder(order.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Job started'.i18n),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('start_job'.i18n),
              ),
            ),
          if (isInProgress)
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final actions = ref.read(incomingOrdersActionsProvider);

                  // ✅ 1. تحديث حالة الطلب إلى completed
                  await actions.completeOrder(order.id);

                  if (context.mounted) Navigator.pop(context);
                  return;

                  if (!context.mounted) return;

                  // ✅ 2. عرض شاشة الدفع
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => PaymentDialog(
                      order: order.order, // تمرير Order الأساسي
                      onSuccess: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Payment successful!'.i18n),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context); // العودة من شاشة التفاصيل
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('complete_job'.i18n),
              ),
            ),
        ],
      ),
    );
  }
}
