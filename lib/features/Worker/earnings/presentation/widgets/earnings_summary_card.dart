import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../translations.dart';
import '../../domain/models/earnings_summary_model.dart';
import '../providers/earnings_provider.dart';

class EarningsSummaryCard extends ConsumerStatefulWidget {
  final EarningsSummaryModel summary;
  final VoidCallback onWithdraw;

  const EarningsSummaryCard({
    super.key,
    required this.summary,
    required this.onWithdraw,
  });

  @override
  ConsumerState<EarningsSummaryCard> createState() =>
      _EarningsSummaryCardState();
}

class _EarningsSummaryCardState extends ConsumerState<EarningsSummaryCard> {
  bool _isWithdrawing = false;

  Future<void> _handleWithdraw() async {
    if (widget.summary.availableBalance <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No balance to withdraw'.i18n)));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Withdraw to Sham Cash'.i18n),
        content: Text(
          'Are you sure you want to withdraw ${widget.summary.availableBalance.toStringAsFixed(0)} \$ to your Sham Cash account?'
              .i18n,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'.i18n),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text('Confirm'.i18n),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isWithdrawing = true);

    try {
      final notifier = ref.read(earningsProvider.notifier);
      await notifier.withdrawToShamCash(
        amount: widget.summary.availableBalance,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Amount transferred to Sham Cash successfully!'.i18n),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        widget.onWithdraw();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'.i18n),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isWithdrawing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'available balance'.i18n,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.surfaceBright.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${widget.summary.availableBalance.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.surfaceBright,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isWithdrawing ? null : _handleWithdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isWithdrawing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'withdraw_to_sham_cash'.i18n,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
