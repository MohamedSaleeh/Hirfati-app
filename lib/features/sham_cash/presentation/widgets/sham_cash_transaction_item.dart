import 'package:flutter/material.dart';
import '../../../../translations.dart';
import '../../domain/models/sham_cash_transaction_model.dart';

class ShamCashTransactionItem extends StatelessWidget {
  final ShamCashTransactionModel transaction;
  final String currentUserId;

  const ShamCashTransactionItem({
    super.key,
    required this.transaction,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = _isCredit();
    final icon = _getIcon();
    final title = _getTitle();
    final subtitle = _getSubtitle();
    final amountColor = isCredit
        ? theme.colorScheme.primary
        : theme.colorScheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCredit
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isCredit
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.createdAt),
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'} ${transaction.amount.toStringAsFixed(0)} \$',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(theme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(fontSize: 10, color: _getStatusColor(theme)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isCredit() {
    return transaction.toUserId == currentUserId;
  }

  IconData _getIcon() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return Icons.add_circle_outline;
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.withdraw:
        return Icons.logout;
    }
  }

  String _getTitle() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return 'Deposit'.i18n;
      case TransactionType.payment:
        return 'Payment'.i18n;
      case TransactionType.transfer:
        return 'Transfer'.i18n;
      case TransactionType.withdraw:
        return 'Withdraw'.i18n;
    }
  }

  String _getSubtitle() {
    if (transaction.type == TransactionType.payment) {
      return _isCredit() ? 'Received from customer' : 'Paid to worker';
    }
    if (transaction.type == TransactionType.transfer) {
      if (_isCredit()) {
        return 'Received from ${transaction.fromUserName ?? 'User'}';
      }
      return 'Sent to ${transaction.toUserName ?? 'User'}';
    }
    return 'Reference: ${transaction.reference.substring(0, 8)}...';
  }

  String _getStatusText() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return 'Pending'.i18n;
      case TransactionStatus.success:
        return 'Success'.i18n;
      case TransactionStatus.failed:
        return 'Failed'.i18n;
    }
  }

  Color _getStatusColor(ThemeData theme) {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return theme.colorScheme.tertiary;
      case TransactionStatus.success:
        return theme.colorScheme.primary;
      case TransactionStatus.failed:
        return theme.colorScheme.error;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
