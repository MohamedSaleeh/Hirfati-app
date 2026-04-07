import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/order.dart';
import '../../../../../translations.dart';
import '../../../../payment/presentation/widgets/payment_dialog.dart';
import '../../data/providers/orders_repository_provider.dart';
import '../../domain/models/order_model.dart';
import '../providers/orders_provider.dart';

class OrderCardWidget extends ConsumerWidget {
  final OrderModel order;

  const OrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarSection(context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.workerName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.profession,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            order.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (order.paymentStatus != PaymentStatus.paid &&
                          order.status == OrderStatus.completed)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Payment Pending',
                            style: TextStyle(
                              color: colorScheme.error,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),
            const SizedBox(height: 16),
            _buildScheduleInfo(context),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildProgressMessage(context)),
                _buildActionButton(context, ref),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color badgeColor = colorScheme.primary;
    IconData badgeIcon = Icons.check;

    switch (order.status) {
      case OrderStatus.pending:
        badgeColor = Colors.orange;
        badgeIcon = Icons.flash_on;
        break;
      case OrderStatus.in_progress:
        badgeColor = Colors.green;
        badgeIcon = Icons.build;
        break;
      case OrderStatus.completed:
        badgeColor = colorScheme.primary;
        badgeIcon = Icons.edit;
        break;
      case OrderStatus.cancelled:
        badgeColor = colorScheme.onSurfaceVariant;
        badgeIcon = Icons.close;
        break;
      case OrderStatus.accepted:
        badgeColor = Colors.teal;
        badgeIcon = Icons.check_circle;
        break;
      case OrderStatus.rejected:
        badgeColor = colorScheme.error;
        badgeIcon = Icons.cancel;
        break;
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: colorScheme.surfaceContainerHighest,
          backgroundImage: order.workerAvatar.isNotEmpty
              ? NetworkImage(order.workerAvatar)
              : null,
          child: order.workerAvatar.isEmpty
              ? Icon(
                  Icons.person,
                  size: 32,
                  color: colorScheme.onSurfaceVariant,
                )
              : null,
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(badgeIcon, size: 12, color: colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color bgColor;
    Color textColor;
    String text;

    switch (order.status) {
      case OrderStatus.pending:
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57F17);
        text = 'PENDING'.i18n;
        break;
      case OrderStatus.accepted:
        bgColor = const Color(0xFFE8F0FE);
        textColor = const Color(0xFF2196F3);
        text = 'ACCEPTED'.i18n;
        break;
      case OrderStatus.in_progress:
        bgColor = const Color(0xFFE1F5FE);
        textColor = const Color(0xFF03A9F4);
        text = 'IN PROGRESS'.i18n;
        break;
      case OrderStatus.completed:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF4CAF50);
        text = 'COMPLETED'.i18n;
        break;
      case OrderStatus.cancelled:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFF44336);
        text = 'CANCELLED'.i18n;
        break;
      case OrderStatus.rejected:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFF44336);
        text = 'REJECTED'.i18n;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildScheduleInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (order.scheduledAt == null) return const SizedBox.shrink();

    final date = order.scheduledAt!;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final timeStr =
        '${date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour)}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
    final dateStr = '${months[date.month - 1]} ${date.day}, $timeStr';

    String labelText = 'Requested for'.i18n;
    IconData icon = Icons.calendar_today_outlined;
    Color iconColor = colorScheme.primary;

    if (order.status == OrderStatus.in_progress) {
      labelText = 'Started at'.i18n;
      icon = Icons.access_time;
      iconColor = Colors.green;
    } else if (order.status == OrderStatus.completed) {
      labelText = 'Completed at'.i18n;
      icon = Icons.check_circle_outline;
      iconColor = colorScheme.primary;
    } else if (order.status == OrderStatus.cancelled) {
      labelText = 'Scheduled for'.i18n;
      icon = Icons.schedule;
      iconColor = colorScheme.onSurfaceVariant;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressMessage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    String message = '';
    Color color = colorScheme.onSurfaceVariant;
    IconData icon = Icons.info_outline;

    switch (order.status) {
      case OrderStatus.pending:
        message = 'Waiting for response'.i18n;
        color = colorScheme.onSurfaceVariant;
        icon = Icons.hourglass_empty;
        break;
      case OrderStatus.accepted:
        message = 'Craftsman accepted your request'.i18n;
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case OrderStatus.in_progress:
        message = 'Work in progress'.i18n;
        color = colorScheme.onSurfaceVariant;
        icon = Icons.people_outline;
        break;
      case OrderStatus.completed:
        if (order.paymentStatus == PaymentStatus.paid) {
          message = 'Job finished successfully'.i18n;
        } else {
          message = 'Payment pending - Please complete payment'.i18n;
          color = Colors.orange;
          icon = Icons.payment;
        }
        break;
      case OrderStatus.cancelled:
        message = 'Order was cancelled'.i18n;
        color = colorScheme.onSurfaceVariant;
        icon = Icons.cancel_outlined;
        break;
      case OrderStatus.rejected:
        message = 'Order was rejected'.i18n;
        color = colorScheme.error;
        icon = Icons.block;
        break;
    }

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, WidgetRef ref) {
    switch (order.status) {
      case OrderStatus.pending:
        return _buildCancelButton(context, ref);
      case OrderStatus.accepted:
      case OrderStatus.in_progress:
        return _buildTrackButton();
      case OrderStatus.completed:
        if (order.paymentStatus == PaymentStatus.paid) {
          return _buildReviewButton(context, ref);
        } else {
          return _buildPayNowButton(context, ref);
        }
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return _buildReorderButton(context, ref);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCancelButton(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      onPressed: () async {
        final shouldCancel = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Cancel Order'.i18n),
            content: Text('Are you sure you want to cancel this order?'.i18n),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'.i18n),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                child: Text('Yes, Cancel'.i18n),
              ),
            ],
          ),
        );

        if (shouldCancel == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cancelling order...'.i18n),
              duration: const Duration(seconds: 1),
            ),
          );

          try {
            final repository = ref.read(ordersRepositoryProvider);
            await repository.cancelOrder(order.id);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order cancelled successfully'.i18n),
                  backgroundColor: Colors.green,
                ),
              );
              ref.invalidate(ordersProvider(OrderStatus.pending));
              ref.invalidate(ordersProvider(OrderStatus.cancelled));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to cancel order: ${e.toString()}'.i18n),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          }
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.error,
        side: BorderSide(color: colorScheme.error),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
      child: Text('Cancel'.i18n),
    );
  }

  Widget _buildTrackButton() {
    return _buildActiveButton(
      text: 'Track'.i18n,
      bgColor: Colors.blue,
      textColor: Colors.white,
      onPressed: () {},
    );
  }

  Widget _buildReviewButton(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasReviewedAsync = ref.watch(orderReviewStatusProvider(order.id));

    return hasReviewedAsync.when(
      data: (hasReviewed) {
        if (hasReviewed) {
          return _buildDisabledButton('Reviewed'.i18n, context);
        }
        return _buildActiveButton(
          text: 'Review'.i18n,
          bgColor: Colors.green,
          textColor: Colors.white,
          onPressed: () async {
            final result = await context.push(
              '/review',
              extra: {
                'orderId': order.id,
                'workerId': order.workerId,
                'workerName': order.workerName,
                'workerAvatar': order.workerAvatar,
                'serviceTitle': order.profession,
                'price': order.price,
              },
            );
            if (result == true) {
              ref.invalidate(orderReviewStatusProvider(order.id));
              ref.invalidate(ordersProvider(OrderStatus.completed));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Review submitted successfully!'.i18n),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          },
        );
      },
      loading: () => _buildActiveButton(
        text: 'Review'.i18n,
        bgColor: Colors.green,
        textColor: Colors.white,
        onPressed: null,
      ),
      error: (_, __) => _buildActiveButton(
        text: 'Review'.i18n,
        bgColor: Colors.green,
        textColor: Colors.white,
        onPressed: () {
          context.push(
            '/review',
            extra: {
              'orderId': order.id,
              'workerId': order.workerId,
              'workerName': order.workerName,
              'workerAvatar': order.workerAvatar,
              'serviceTitle': order.profession,
              'price': order.price,
            },
          );
        },
      ),
    );
  }

  Widget _buildPayNowButton(BuildContext context, WidgetRef ref) {
    return _buildActiveButton(
      text: 'Pay Now'.i18n,
      bgColor: Colors.orange,
      textColor: Colors.white,
      onPressed: () => _showPaymentDialog(context, ref),
      showIcon: true,
      icon: Icons.payment,
    );
  }

  Widget _buildReorderButton(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: () async {
        final shouldReorder = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Reorder Service'.i18n),
            content: Text('Do you want to place this order again?'.i18n),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'.i18n),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
                child: Text('Yes, Reorder'.i18n),
              ),
            ],
          ),
        );

        if (shouldReorder == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Creating new order...'.i18n),
              duration: const Duration(seconds: 1),
            ),
          );

          try {
            final repository = ref.read(ordersRepositoryProvider);
            await repository.reorder(order.id);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order created successfully!'.i18n),
                  backgroundColor: Colors.green,
                ),
              );
              ref.invalidate(ordersProvider(OrderStatus.pending));
              ref.invalidate(ordersProvider(OrderStatus.cancelled));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to reorder: ${e.toString()}'.i18n),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      ),
      child: Text('Reorder'.i18n),
    );
  }

  Widget _buildActiveButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    VoidCallback? onPressed,
    bool showIcon = false,
    IconData? icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          if (showIcon && icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildDisabledButton(String text, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final orderCore = Order(
      id: order.id,
      clientId: '',
      clientName: '',
      clientAvatarUrl: null,
      workerId: order.workerId,
      workerName: order.workerName,
      workerAvatarUrl: order.workerAvatar,
      serviceId: null,
      serviceTitle: order.profession,
      price: order.price,
      status: order.status,
      paymentStatus: order.paymentStatus,
      requestType: OrderRequestType.scheduled,
      address: '',
      latitude: null,
      longitude: null,
      description: null,
      scheduledAt: order.scheduledAt,
      startedAt: null,
      completedAt: null,
      paidAt: order.paidAt,
      paymentMethod: order.paymentMethod,
      paymentTransactionId: null,
      distance: 0.0,
      rating: order.rating,
      createdAt: DateTime.now(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentDialog(
        order: orderCore,
        onSuccess: () {
          ref.invalidate(ordersProvider(OrderStatus.completed));
          ref.invalidate(ordersProvider(OrderStatus.pending));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment successful!'.i18n),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
