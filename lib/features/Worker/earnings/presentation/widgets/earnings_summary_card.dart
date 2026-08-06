import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../translations.dart';
import '../../domain/models/earnings_summary_model.dart';

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
              onPressed: null,
              child: Text('Withdrawal is currently unavailable'.i18n),
            ),
          ),
        ],
      ),
    );
  }
}
