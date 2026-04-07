import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../translations.dart';
import '../../data/providers/sham_cash_providers.dart';
import '../widgets/sham_cash_balance_card.dart';
import '../widgets/sham_cash_transaction_item.dart';

class ShamCashDetailsScreen extends ConsumerStatefulWidget {
  const ShamCashDetailsScreen({super.key});

  @override
  ConsumerState<ShamCashDetailsScreen> createState() =>
      _ShamCashDetailsScreenState();
}

class _ShamCashDetailsScreenState extends ConsumerState<ShamCashDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountAsync = ref.watch(shamCashAccountProvider);
    final transactionsAsync = ref.watch(shamCashTransactionsProvider);
    final currentUser = ref.read(supabaseClientProvider).auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sham Cash Wallet'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(shamCashAccountProvider);
          ref.invalidate(shamCashTransactionsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              accountAsync.when(
                data: (account) => ShamCashBalanceCard(account: account),
                loading: () => Center(
                  child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/loading_animation.json',
                        width: 150,
                        height: 150,
                        repeat: true,
                      ),
                    ),
                  ),
                ),
                error: (error, _) => Container(
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load balance',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions'.i18n,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All'.i18n,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions yet'.i18n,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length > 10
                        ? 10
                        : transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ShamCashTransactionItem(
                        transaction: transaction,
                        currentUserId: currentUser?.id ?? '',
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Lottie.asset(
                      'assets/animations/loading_animation.json',
                      width: 150,
                      height: 150,
                      repeat: true,
                    ),
                  ),
                ),
                error: (error, _) => Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: theme.colorScheme.error),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load transactions',
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
