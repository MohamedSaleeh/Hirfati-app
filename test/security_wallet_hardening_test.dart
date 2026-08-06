import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/features/wallet/domain/models/wallet_models.dart';

void main() {
  group('wallet ledger model', () {
    test('parses debit transactions with signed amounts', () {
      final transaction = WalletTransaction.fromJson({
        'id': 'tx-1',
        'wallet_user_id': 'user-1',
        'direction': 'debit',
        'transaction_type': 'payment',
        'amount': 25,
        'balance_before': 100,
        'balance_after': 75,
        'status': 'completed',
        'currency': 'SYP',
        'order_id': 'order-1',
        'payment_id': 'payment-1',
        'transfer_group': 'transfer-1',
        'idempotency_key': 'order:order-1:wallet:user:user-1:client_debit',
        'created_at': '2026-07-21T10:00:00Z',
      });

      expect(transaction.isDebit, isTrue);
      expect(transaction.signedAmount, -25);
      expect(transaction.balanceBefore, 100);
      expect(transaction.balanceAfter, 75);
      expect(transaction.orderId, 'order-1');
      expect(transaction.transferGroup, 'transfer-1');
    });

    test('parses credit transactions with signed amounts', () {
      final transaction = WalletTransaction.fromJson({
        'id': 'tx-2',
        'wallet_user_id': 'worker-user-1',
        'direction': 'credit',
        'transaction_type': 'payment',
        'amount': '40.50',
        'balance_before': '10',
        'balance_after': '50.50',
        'status': 'completed',
        'currency': 'SYP',
        'idempotency_key': 'order:order-1:wallet:user:user-1:worker_credit',
      });

      expect(transaction.isCredit, isTrue);
      expect(transaction.signedAmount, 40.5);
      expect(transaction.balanceAfter, 50.5);
    });

    test('supports the legacy transfer group cache key', () {
      final transaction = WalletTransaction.fromJson({
        'id': 'tx-legacy',
        'wallet_user_id': 'user-1',
        'direction': 'credit',
        'transaction_type': 'payment',
        'amount': 10,
        'balance_before': 0,
        'balance_after': 10,
        'status': 'completed',
        'transfer_group_id': 'legacy-transfer',
        'idempotency_key': 'legacy-transfer',
      });

      expect(transaction.transferGroup, 'legacy-transfer');
    });

    test('metadata helper excludes sensitive keys', () {
      final safe = safeWalletMetadataFields({
        'provider': 'wallet',
        'amount': 10,
        'token': 'secret-token',
        'card_last4': '4242',
      });

      expect(safe, {'provider': 'wallet', 'amount': '10'});
    });
  });

  group('client-side security guardrails', () {
    test('Flutter code does not reference the Supabase Service Role key', () {
      expect(
        _readDartAndPubspec().contains('SUPABASE_SERVICE_ROLE_KEY'),
        isFalse,
      );
    });

    test('pubspec does not bundle local env files as assets', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();

      expect(
        RegExp(r'^\s*-\s+\.env\s*$', multiLine: true).hasMatch(pubspec),
        isFalse,
      );
    });

    test('Firebase service account file is not present in the app root', () {
      expect(File('firebase-service-account.json').existsSync(), isFalse);
    });

    test(
      'payment datasource uses the settlement RPC without trusted client amounts or parties',
      () {
        final source = File(
          'lib/features/payment/data/datasources/payment_supabase_datasource.dart',
        ).readAsStringSync();

        expect(source.contains('settle_order_payment'), isTrue);
        expect(source.contains('p_amount'), isFalse);
        expect(source.contains('p_user_id'), isFalse);
        expect(source.contains('p_worker_id'), isFalse);
        expect(source.contains(".from('payments').insert"), isFalse);
        expect(source.contains(".from('payments').update"), isFalse);
      },
    );

    test('Phase 1 migration keeps card and cash settlement unavailable', () {
      final source = File(
        'supabase/migrations/20260721000200_wallet_payment_phase1_validation.sql',
      ).readAsStringSync();

      expect(source.contains('pg_advisory_xact_lock'), isTrue);
      expect(source.contains('payment_method_unavailable'), isTrue);
      expect(source.contains('wallet_balance_is_server_managed'), isTrue);
      expect(
        source.contains('order_payment_settlement_is_server_managed'),
        isTrue,
      );
    });
  });
}

String _readDartAndPubspec() {
  final buffer = StringBuffer()
    ..writeln(File('pubspec.yaml').readAsStringSync());
  final lib = Directory('lib');

  for (final entity in lib.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    buffer.writeln(entity.readAsStringSync());
  }

  return buffer.toString();
}
