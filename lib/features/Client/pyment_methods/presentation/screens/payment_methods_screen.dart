import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../../translations.dart';
import '../providers/payment_methods_provider.dart';
import '../widgets/credit_card_widget.dart';
import '../widgets/add_card_button_widget.dart';
import '../widgets/other_method_widget.dart';
import '../widgets/transaction_history_widget.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  bool _showAllHistory = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('Payment Methods'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Cards'.i18n,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/add-payment-method'),
                    child: Text(
                      'Edit'.i18n,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            paymentMethodsAsync.when(
              data: (cards) {
                return SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      ...cards.map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: CreditCardWidget(
                            card: card,
                            onEdit: () {},
                            onDelete: () async {
                              final confirmed = await _showDeleteDialog(
                                context,
                              );
                              if (confirmed) {
                                await ref
                                    .read(paymentMethodsProvider.notifier)
                                    .deletePaymentMethod(card.id);
                              }
                            },
                            onSetDefault: () {
                              ref
                                  .read(paymentMethodsProvider.notifier)
                                  .setDefaultPaymentMethod(card.id);
                            },
                          ),
                        ),
                      ),
                      AddCardButtonWidget(
                        onTap: () => context.push('/add-payment-method'),
                      ),
                    ],
                  ),
                );
              },
              loading: () => SizedBox(
                height: 200,
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading_animation.json',
                    width: 150,
                    height: 150,
                    repeat: true,
                  ),
                ),
              ),
              error: (error, _) => SizedBox(
                height: 200,
                child: Center(child: Text('Error: \$error'.i18n)),
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Other Methods'.i18n,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 12),

            OtherMethodWidget(
              icon: Icons.apple,
              title: 'Apple Pay',
              subtitle: 'Fast & secure checkout',
              color: Colors.black,
              onTap: () => _showDemoMessage(context, 'Apple Pay'),
            ),
            OtherMethodWidget(
              icon: Icons.android,
              title: 'Google Pay',
              subtitle: 'Send to test@email.com',
              color: const Color(0xFF4285F4),
              onTap: () => _showDemoMessage(context, 'Google Pay'),
            ),

            const SizedBox(height: 32),

            transactionsAsync.when(
              data: (transactions) {
                return TransactionHistoryWidget(
                  transactions: _showAllHistory
                      ? transactions
                      : transactions.take(3).toList(),
                  onViewAll: () {
                    setState(() {
                      _showAllHistory = !_showAllHistory;
                    });
                  },
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
              error: (error, _) => Center(child: Text('Error: \$error'.i18n)),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    final theme = Theme.of(context);
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Card'.i18n),
        content: Text('Are you sure you want to delete this card?'.i18n),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'.i18n),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text('Delete'.i18n),
          ),
        ],
      ),
    );
  }

  void _showDemoMessage(BuildContext context, String method) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '\$method is in demo mode. No real payment will be processed.'.i18n,
        ),
        backgroundColor: theme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
