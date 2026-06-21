import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../../translations.dart';
import '../providers/earnings_provider.dart';
import '../providers/transactions_view_provider.dart';
import '../widgets/earnings_summary_card.dart';
import '../widgets/earnings_stats_card.dart';
import '../widgets/transaction_item.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(earningsProvider);
    final showAll = ref.watch(showAllTransactionsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('earnings_summary'.i18n),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: colorScheme.primary),
            onPressed: () {
              context.push('/worker/withdrawal-history');
            },
            tooltip: 'withdrawal_history'.i18n,
          ),
        ],
      ),
      body: earningsAsync.when(
        data: (data) {
          final (summary, transactions) = data;

          final displayTransactions = showAll
              ? transactions
              : transactions.take(5).toList();

          final hasMore = transactions.length > 5;

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(earningsProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Summary Card
                  EarningsSummaryCard(
                    summary: summary,
                    onWithdraw: () async {
                      final result = await context.push<bool>(
                        '/worker/withdraw',
                        extra: {'availableBalance': summary.availableBalance},
                      );
                      if (result == true) {
                        ref.invalidate(earningsProvider);
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  // Stats Card
                  EarningsStatsCard(
                    thisWeekEarnings: summary.thisWeekEarnings,
                    weeklyChangePercent: summary.weeklyChangePercent,
                    totalOrders: summary.totalOrders,
                    completedOrders: summary.completedOrders,
                  ),
                  const SizedBox(height: 24),

                  // Recent Transactions Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'recent_transactions'.i18n,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hasMore)
                          TextButton(
                            onPressed: () {
                              ref
                                      .read(
                                        showAllTransactionsProvider.notifier,
                                      )
                                      .state =
                                  !showAll;
                            },
                            child: Text(
                              showAll ? 'show_less'.i18n : 'view_all'.i18n,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Transactions List
                  if (displayTransactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            size: 48,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'no_transactions'.i18n,
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayTransactions.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 60),
                        itemBuilder: (context, index) {
                          final transaction = displayTransactions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TransactionItem(transaction: transaction),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
        loading: () =>  Center(
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
              Text('error_loading_earnings'.i18n, style: TextStyle(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(earningsProvider),
                child: Text('retry'.i18n, style: TextStyle(color: colorScheme.onPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
