import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/features/wallet/domain/models/wallet_models.dart';

void main() {
  test('parses final wallet ledger transfer_group fields', () {
    final transaction = WalletTransaction.fromJson({
      'id': 'ledger-1',
      'wallet_user_id': 'user-1',
      'counterparty_user_id': 'user-2',
      'payment_id': 'payment-1',
      'order_id': 'order-1',
      'transaction_type': 'payment',
      'direction': 'debit',
      'amount': '2500',
      'balance_before': '10000',
      'balance_after': '7500',
      'status': 'completed',
      'transfer_group': 'group-1',
      'currency': 'USD',
      'title': 'Order payment',
      'description': 'Payment description',
      'created_at': '2026-08-06T10:00:00Z',
    });

    expect(transaction.walletUserId, 'user-1');
    expect(transaction.transferGroup, 'group-1');
    expect(transaction.transactionType, 'payment');
    expect(transaction.balanceBefore, 10000);
    expect(transaction.balanceAfter, 7500);
    expect(transaction.currency, 'USD');
    expect(transaction.amount, 2500);
  });

  test('defaults a missing wallet ledger currency to USD', () {
    final transaction = WalletTransaction.fromJson({
      'id': 'ledger-2',
      'wallet_user_id': 'user-1',
      'amount': 19.5,
      'balance_before': 10,
      'balance_after': 29.5,
    });

    expect(transaction.currency, 'USD');
    expect(transaction.amount, 19.5);
  });
}
