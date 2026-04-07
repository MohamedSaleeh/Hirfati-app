import 'package:flutter/material.dart';
import '../../../../translations.dart';
import '../../domain/models/sham_cash_account_model.dart';

class ShamCashBalanceCard extends StatelessWidget {
  final ShamCashAccountModel? account;

  const ShamCashBalanceCard({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balance = account?.balance ?? 0;
    final accountCode = account?.accountCode ?? '---';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sham Cash Balance'.i18n,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$balance \$',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: theme.colorScheme.onPrimary.withOpacity(0.3)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.qr_code,
                size: 16,
                color: theme.colorScheme.onPrimary.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Account Code: $accountCode',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
