import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../../translations.dart';
import '../../domain/models/wallet_models.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final walletAsync = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('Wallet'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh'.i18n,
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshWallet(ref),
          ),
        ],
      ),
      body: walletAsync.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () => _refreshWallet(ref),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _WalletBalanceCard(data: data),
                const SizedBox(height: 24),
                _TransactionHistorySection(
                  transactions: data.transactions,
                  onTransactionTap: (transaction) {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      backgroundColor: theme.colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (_) =>
                          _TransactionDetailsSheet(transaction: transaction),
                    );
                  },
                ),
              ],
            ),
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
        error: (error, _) => _WalletErrorState(
          message: error is WalletUnauthenticatedException
              ? 'User not authenticated'.i18n
              : 'Unable to load wallet'.i18n,
          onRetry: () => ref.invalidate(walletProvider),
        ),
      ),
    );
  }

  Future<void> _refreshWallet(WidgetRef ref) async {
    ref.invalidate(walletProvider);
    try {
      await ref.read(walletProvider.future);
    } catch (_) {
      // The error state is rendered by walletProvider.
    }
  }
}

class _WalletBalanceCard extends StatelessWidget {
  final WalletData data;

  const _WalletBalanceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final updatedAt = data.wallet.updatedAt ?? data.wallet.createdAt;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Current balance'.i18n,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              _formatAmount(data.wallet.balance),
              style: theme.textTheme.displaySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            !data.walletExists
                ? 'Wallet not initialized yet'.i18n
                : '${'Last updated'.i18n}: ${_formatDateOrUnknown(updatedAt)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionHistorySection extends StatelessWidget {
  final List<WalletTransaction> transactions;
  final ValueChanged<WalletTransaction> onTransactionTap;

  const _TransactionHistorySection({
    required this.transactions,
    required this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wallet activity'.i18n,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          _WalletEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No wallet activity yet'.i18n,
            subtitle: 'Wallet transactions will appear here'.i18n,
          )
        else
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 72,
                color: colorScheme.surfaceContainerHighest,
              ),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _TransactionTile(
                  transaction: transaction,
                  onTap: () => onTransactionTap(transaction),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  final VoidCallback onTap;

  const _TransactionTile({required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _transactionColor(transaction, theme).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _transactionIcon(transaction),
          color: _transactionColor(transaction, theme),
          size: 22,
        ),
      ),
      title: Text(
        _transactionTitle(transaction),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDateOrUnknown(transaction.createdAt),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (transaction.orderId != null) ...[
              const SizedBox(height: 4),
              Text(
                '${'Order ID'.i18n}: ${transaction.orderId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (transaction.description != null) ...[
              const SizedBox(height: 4),
              Text(
                transaction.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 8),
            _StatusChip(status: transaction.displayStatus),
          ],
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatSignedAmount(transaction.signedAmount, transaction.currency),
            style: theme.textTheme.titleMedium?.copyWith(
              color: _transactionColor(transaction, theme),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _TransactionDetailsSheet extends ConsumerWidget {
  final WalletTransaction transaction;

  const _TransactionDetailsSheet({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paymentId = transaction.paymentId;
    final eventsAsync = ref.watch(paymentEventsProvider(paymentId ?? ''));
    final safeMetadata = safeWalletMetadataFields(transaction.metadata);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _transactionIcon(transaction),
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Transaction details'.i18n,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _DetailRow(
              icon: Icons.attach_money,
              label: 'Amount'.i18n,
              value: _formatSignedAmount(
                transaction.signedAmount,
                transaction.currency,
              ),
              highlighted: true,
            ),
            _DetailRow(
              icon: Icons.swap_vert,
              label: 'Direction'.i18n,
              value: _formatEnumLabel(transaction.direction),
            ),
            _DetailRow(
              icon: Icons.category_outlined,
              label: 'Transaction Type'.i18n,
              value: _formatEnumLabel(transaction.transactionType),
            ),
            _DetailRow(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Balance before'.i18n,
              value: _formatAmount(
                transaction.balanceBefore,
                transaction.currency,
              ),
            ),
            _DetailRow(
              icon: Icons.account_balance_wallet,
              label: 'Balance after'.i18n,
              value: _formatAmount(
                transaction.balanceAfter,
                transaction.currency,
              ),
            ),
            _DetailRow(
              icon: Icons.info_outline,
              label: 'Status'.i18n,
              value: _statusLabel(transaction.displayStatus),
            ),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Created at'.i18n,
              value: _formatDateOrNull(transaction.createdAt),
            ),
            _DetailRow(
              icon: Icons.shopping_bag_outlined,
              label: 'Order ID'.i18n,
              value: transaction.orderId,
            ),
            _DetailRow(
              icon: Icons.payments_outlined,
              label: 'Payment ID'.i18n,
              value: transaction.paymentId,
            ),
            _DetailRow(
              icon: Icons.account_balance,
              label: 'Withdrawal ID'.i18n,
              value: transaction.withdrawalId,
            ),
            _DetailRow(
              icon: Icons.support_agent,
              label: 'Ledger ID'.i18n,
              value: transaction.id,
            ),
            if (safeMetadata.isNotEmpty) ...[
              const SizedBox(height: 12),
              _SheetSectionTitle(title: 'Additional details'.i18n),
              const SizedBox(height: 8),
              ...safeMetadata.entries.map(
                (entry) => _DetailRow(
                  icon: Icons.notes_outlined,
                  label: _metadataLabel(entry.key),
                  value: entry.value,
                ),
              ),
            ],
            if (paymentId != null) ...[
              const SizedBox(height: 16),
              _SheetSectionTitle(title: 'Payment events'.i18n),
              const SizedBox(height: 8),
              eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return Text(
                      'No payment events yet'.i18n,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  }

                  return Column(
                    children: events
                        .map((event) => _PaymentEventTile(event: event))
                        .toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(minHeight: 2),
                ),
                error: (error, stackTrace) => Text(
                  'Unable to load payment events'.i18n,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PaymentEventTile extends StatelessWidget {
  final WalletPaymentEvent event;

  const _PaymentEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final safeEventData = safeWalletMetadataFields(event.eventData);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatEnumLabel(event.eventType),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDateOrUnknown(event.createdAt),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (safeEventData.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...safeEventData.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${_metadataLabel(entry.key)}: ${entry.value}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool highlighted;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayValue = value == null || value!.trim().isEmpty
        ? 'Unknown'.i18n
        : value!.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                SelectableText(
                  displayValue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: highlighted ? FontWeight.bold : FontWeight.w500,
                    color: highlighted
                        ? colorScheme.primary
                        : colorScheme.onSurface,
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

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(status, theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(status),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SheetSectionTitle extends StatelessWidget {
  final String title;

  const _SheetSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _WalletEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WalletEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _WalletErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('Retry'.i18n),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatAmount(double amount, [String currency = 'SYP']) {
  final normalized = amount.abs() < 0.005 ? 0.0 : amount;
  final rounded = normalized.roundToDouble();
  final amountText = (normalized - rounded).abs() < 0.005
      ? normalized.toStringAsFixed(0)
      : normalized.toStringAsFixed(2);

  return '$amountText $currency';
}

String _formatSignedAmount(double amount, [String currency = 'SYP']) {
  final prefix = amount > 0
      ? '+'
      : amount < 0
      ? '-'
      : '';
  return '$prefix${_formatAmount(amount.abs(), currency)}';
}

String _formatDate(DateTime date) {
  return app_date_utils.DateUtils.formatDateTime(date);
}

String _formatDateOrUnknown(DateTime? date) {
  if (date == null) return 'Unknown'.i18n;
  return _formatDate(date);
}

String? _formatDateOrNull(DateTime? date) {
  if (date == null) return null;
  return _formatDate(date);
}

String _statusLabel(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Pending'.i18n;
    case 'success':
    case 'paid':
    case 'completed':
      return 'Successful'.i18n;
    case 'failed':
      return 'Failed'.i18n;
    case 'cancelled':
    case 'canceled':
      return 'Cancelled'.i18n;
    case 'refunded':
      return 'Refunded'.i18n;
    default:
      return status.trim().isEmpty ? 'Unknown'.i18n : _formatEnumLabel(status);
  }
}

Color _statusColor(String status, ThemeData theme) {
  final colorScheme = theme.colorScheme;

  switch (status.toLowerCase()) {
    case 'pending':
      return colorScheme.secondary;
    case 'success':
    case 'paid':
    case 'completed':
      return colorScheme.tertiary;
    case 'failed':
    case 'cancelled':
    case 'canceled':
      return colorScheme.error;
    case 'refunded':
      return colorScheme.primary;
    default:
      return colorScheme.outline;
  }
}

String _transactionTitle(WalletTransaction transaction) {
  final title = transaction.displayTitle.trim();
  if (title.isEmpty) return 'Wallet transaction'.i18n;
  return _formatEnumLabel(title);
}

IconData _transactionIcon(WalletTransaction transaction) {
  final type = transaction.transactionType.toLowerCase();
  if (type.contains('withdrawal')) return Icons.account_balance_outlined;
  if (type.contains('refund')) return Icons.undo;
  if (transaction.isDebit) return Icons.arrow_upward;
  return Icons.arrow_downward;
}

Color _transactionColor(WalletTransaction transaction, ThemeData theme) {
  final colorScheme = theme.colorScheme;
  if (transaction.displayStatus.toLowerCase() == 'failed') {
    return colorScheme.error;
  }
  if (transaction.isDebit) return colorScheme.error;
  return colorScheme.tertiary;
}

String _metadataLabel(String key) {
  switch (key.toLowerCase()) {
    case 'amount':
      return 'Amount'.i18n;
    case 'fee':
      return 'Fee'.i18n;
    case 'order_id':
      return 'Order ID'.i18n;
    case 'payment_method':
      return 'Payment Method'.i18n;
    case 'provider':
      return 'Provider'.i18n;
    case 'reference_number':
      return 'Reference Number'.i18n;
    case 'status':
      return 'Status'.i18n;
    case 'transaction_id':
      return 'Transaction ID'.i18n;
    case 'transaction_type':
      return 'Transaction Type'.i18n;
    default:
      return _formatEnumLabel(key);
  }
}

String _formatEnumLabel(String value) {
  final words = value
      .trim()
      .split(RegExp(r'[_\s-]+'))
      .where((word) => word.isNotEmpty)
      .map((word) {
        if (word.length == 1) return word.toUpperCase();
        return '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join(' ');

  return words.isEmpty ? 'Unknown'.i18n : words.i18n;
}
