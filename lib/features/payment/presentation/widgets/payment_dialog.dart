import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/order.dart';
import '../../../../translations.dart';
import '../providers/payment_notifier.dart';
import '../screens/card_payment_screen.dart';

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
  String _selectedMethod = 'cash';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            '${widget.order.price} \$',
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
    final theme = Theme.of(context);
    setState(() => _isProcessing = true);

    try {
      final paymentNotifier = ref.read(paymentNotifierProvider.notifier);

      bool success = false;

      if (_selectedMethod == 'card') {
        final cardDetails = await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) => CardPaymentScreen(amount: widget.order.price),
          ),
        );

        if (cardDetails == null) {
          setState(() => _isProcessing = false);
          return;
        }

        success = await paymentNotifier.processPayment(
          order: widget.order,
          paymentMethod: _selectedMethod,
          cardDetails: cardDetails,
        );
      }  else {
        success = await paymentNotifier.processPayment(
          order: widget.order,
          paymentMethod: _selectedMethod,
        );
      }

      if (success && mounted ) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'.i18n),
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
}
