import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/order.dart';
import '../../../../translations.dart';
import '../providers/payment_notifier.dart';

class PaymentDialog extends ConsumerStatefulWidget {
  final Order order;
  final VoidCallback onSuccess;

  const PaymentDialog({
    super.key,
    required this.order,
    required this.onSuccess,
  });

  @override
  ConsumerState<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<PaymentDialog> {
  String _selectedMethod = 'wallet';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildOrderDetails(),
            const SizedBox(height: 24),
            _buildPaymentMethods(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: theme.colorScheme.primary,
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Service completed successfully'.i18n,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please pay the due amount to the worker'.i18n,
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow('Service'.i18n, widget.order.serviceTitle),
          const SizedBox(height: 8),
          _buildDetailRow('Worker'.i18n, widget.order.workerName),
          const Divider(height: 24),
          _buildDetailRow(
            'Total Amount'.i18n,
            '${widget.order.price} SYP',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isTotal ? FontWeight.bold : null,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : null,
            fontSize: isTotal ? 16 : null,
            color: isTotal
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method'.i18n,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          child: Banner(
            location: BannerLocation.topEnd,
            message: "soon".i18n,
            color: theme.colorScheme.secondary,
            child: RadioListTile(
              enabled: false,
              title: Row(
                children: [
                  Icon(
                    Icons.money,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Text('Cash Payment'.i18n),
                ],
              ),
              value: 'cash',
              groupValue: _selectedMethod,
              onChanged: (value) {
                setState(() => _selectedMethod = value!);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        ClipRRect(
          child: Banner(
            location: BannerLocation.topEnd,
            message: "soon".i18n,
            color: theme.colorScheme.secondary,
            child: RadioListTile(
              enabled: false,
              title: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Text('Credit Card Payment'.i18n),
                ],
              ),
              value: 'card',
              groupValue: _selectedMethod,
              onChanged: (value) {
                setState(() => _selectedMethod = value!);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        RadioListTile(
          title: Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text('App Wallet Payment'.i18n),
            ],
          ),
          value: 'wallet',
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() => _selectedMethod = value!);
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildActions() {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            child: Text('Later'.i18n),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isProcessing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Text('Confirm Payment'.i18n),
          ),
        ),
      ],
    );
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    final theme = Theme.of(context);
    setState(() => _isProcessing = true);

    try {
      final paymentNotifier = ref.read(paymentNotifierProvider.notifier);

      bool success = false;

      success = await paymentNotifier.processPayment(
        order: widget.order,
        paymentMethod: _selectedMethod,
      );

      if (success && mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_paymentUnavailableMessage(_selectedMethod).i18n),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_paymentErrorMessage(e).i18n),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  String _paymentUnavailableMessage(String method) {
    switch (method) {
      case 'cash':
        return 'Cash payment needs worker confirmation and is not available yet';
      case 'card':
        return 'Card payment is not available yet';
      default:
        return 'Payment could not be completed';
    }
  }

  String _paymentErrorMessage(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('insufficient_wallet_balance')) {
      return 'Insufficient wallet balance';
    }
    if (text.contains('already_paid') || text.contains('already paid')) {
      return 'This order is already paid';
    }
    if (text.contains('invalid_order_state')) {
      return 'This order cannot be paid in its current state';
    }
    if (text.contains('unauthenticated')) {
      return 'Please sign in again';
    }
    if (text.contains('forbidden') || text.contains('unauthorized')) {
      return 'You are not allowed to pay this order';
    }
    return 'Payment could not be completed';
  }
}
