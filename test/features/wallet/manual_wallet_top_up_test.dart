import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/DashBoard/domain/repositories/admin_wallet_deposit_repository.dart';
import 'package:hirfati/DashBoard/models/admin_wallet_deposit_models.dart';
import 'package:hirfati/DashBoard/providers/dashboard_providers.dart';
import 'package:hirfati/DashBoard/widgets/dashboard_components.dart';
import 'package:hirfati/features/wallet/domain/models/wallet_models.dart';
import 'package:hirfati/features/wallet/domain/wallet_whatsapp_top_up.dart';
import 'package:hirfati/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hirfati/features/wallet/presentation/screens/wallet_screen.dart';

void main() {
  group('WhatsApp wallet top-up', () {
    test('normalizes configured support numbers', () {
      expect(
        WalletWhatsAppTopUp.normalizeNumber('+963 944-123-456'),
        '963944123456',
      );
      expect(
        WalletWhatsAppTopUp.normalizeNumber('00963 944 123 456'),
        '963944123456',
      );
    });

    test('encodes a prepared message containing the Client UUID', () {
      const userId = '11111111-2222-3333-4444-555555555555';
      final message = WalletWhatsAppTopUp.buildArabicMessage(
        userId: userId,
        fullName: 'Client Name',
        phone: '0999999999',
        amount: '25000',
      );
      final uri = WalletWhatsAppTopUp.buildUri(
        number: '+963 944-123-456',
        message: message,
      );

      expect(message, contains(userId));
      expect(uri.host, 'wa.me');
      expect(uri.path, '/963944123456');
      expect(uri.queryParameters['text'], message);
      expect(message, contains('USD'));

      final fallback = WalletWhatsAppTopUp.buildFallbackUri(
        number: '+963 944-123-456',
        message: message,
      );
      expect(fallback.host, 'api.whatsapp.com');
      expect(fallback.path, '/send');
      expect(fallback.queryParameters['phone'], '963944123456');
      expect(fallback.queryParameters['text'], message);
    });

    testWidgets('failed primary launch uses the HTTPS fallback', (
      tester,
    ) async {
      final hosts = <String>[];
      await _pumpWallet(
        tester,
        launcher: (uri) async {
          hosts.add(uri.host);
          return uri.host == 'api.whatsapp.com';
        },
      );

      await tester.tap(find.text('شحن الرصيد عبر واتساب'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('wallet-top-up-launch')));
      await tester.pumpAndSettle();

      expect(hosts, ['wa.me', 'api.whatsapp.com']);
      expect(find.byKey(const Key('wallet-top-up-amount')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('both failed HTTPS launches keep the dialog usable', (
      tester,
    ) async {
      var calls = 0;
      await _pumpWallet(
        tester,
        launcher: (_) async {
          calls++;
          return false;
        },
      );

      await tester.tap(find.text('شحن الرصيد عبر واتساب'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('wallet-top-up-launch')));
      await tester.pumpAndSettle();

      expect(calls, 2);
      expect(find.byKey(const Key('wallet-top-up-amount')), findsOneWidget);
      expect(find.textContaining('تعذر فتح واتساب'), findsOneWidget);
    });

    testWidgets('missing support configuration does not attempt launch', (
      tester,
    ) async {
      var calls = 0;
      await _pumpWallet(
        tester,
        supportNumber: '',
        launcher: (_) async {
          calls++;
          return true;
        },
      );

      await tester.tap(find.text('شحن الرصيد عبر واتساب'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('wallet-top-up-launch')));
      await tester.pumpAndSettle();

      expect(calls, 0);
      expect(
        find.textContaining('غير مضاف في إعدادات التطبيق'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('wallet-top-up-amount')), findsOneWidget);
    });

    testWidgets(
      'dialog preserves input after launch failure and prevents duplicate taps',
      (tester) async {
        final launchGate = Completer<bool>();
        var launchCalls = 0;
        await _pumpWallet(
          tester,
          launcher: (uri) {
            launchCalls++;
            return launchGate.future;
          },
        );

        await tester.tap(find.text('شحن الرصيد عبر واتساب'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        final amountField = find.byKey(const Key('wallet-top-up-amount'));
        await tester.enterText(amountField, '25000');
        await tester.tap(find.byKey(const Key('wallet-top-up-launch')));
        await tester.tap(find.byKey(const Key('wallet-top-up-launch')));
        await tester.pump();
        expect(launchCalls, 1);

        launchGate.complete(false);
        await tester.pumpAndSettle();
        expect(find.text('25000'), findsOneWidget);
        expect(tester.widget<TextField>(amountField).enabled, isTrue);
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('إلغاء'));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('wallet-top-up-amount')), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('successful launch closes the dialog once', (tester) async {
      await _pumpWallet(tester, launcher: (_) async => true);

      await tester.tap(find.text('شحن الرصيد عبر واتساب'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('wallet-top-up-amount')),
        '1250',
      );
      await tester.tap(find.byKey(const Key('wallet-top-up-launch')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('wallet-top-up-amount')), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  test(
    'Android manifest declares regular and Business WhatsApp visibility',
    () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      expect(manifest, contains('android:name="com.whatsapp"'));
      expect(manifest, contains('android:name="com.whatsapp.w4b"'));
      expect(manifest, contains('android:scheme="whatsapp"'));
      expect(manifest, isNot(contains('QUERY_ALL_PACKAGES')));
    },
  );

  group('Admin manual deposit', () {
    const request = AdminWalletDepositRequest(
      userId: 'client-1',
      amount: 25000,
      reference: 'receipt-42',
      note: 'WhatsApp receipt',
      idempotencyKey: 'stable-key',
    );

    test('maps RPC parameters and retains a stable idempotency key', () {
      expect(request.toRpcParameters(), {
        'p_user_id': 'client-1',
        'p_amount': 25000.0,
        'p_reference': 'receipt-42',
        'p_note': 'WhatsApp receipt',
        'p_idempotency_key': 'stable-key',
      });
      expect(request.toRpcParameters()['p_idempotency_key'], 'stable-key');
    });

    test('validates positive amounts and required references', () {
      expect(request.validate(), isNull);
      expect(
        const AdminWalletDepositRequest(
          userId: 'client-1',
          amount: 0,
          reference: 'receipt',
          idempotencyKey: 'key',
        ).validate(),
        'invalid_deposit_amount',
      );
      expect(
        const AdminWalletDepositRequest(
          userId: 'client-1',
          amount: 1,
          reference: ' ',
          idempotencyKey: 'key',
        ).validate(),
        'missing_external_reference',
      );
    });

    test('parses the structured RPC response', () {
      final result = AdminWalletDepositResult.fromJson({
        'success': true,
        'idempotent': false,
        'transaction_id': 'transaction-1',
        'transfer_group': 'group-1',
        'user_id': 'client-1',
        'amount': '25000',
        'currency': 'USD',
        'balance_before': '1000',
        'balance_after': '26000',
        'external_reference': 'receipt-42',
        'created_at': '2026-08-06T10:00:00Z',
      });

      expect(result.transactionId, 'transaction-1');
      expect(result.balanceAfter, 26000);
      expect(result.externalReference, 'receipt-42');
      expect(result.currency, 'USD');
    });

    test(
      'prevents duplicate submission and refreshes providers once',
      () async {
        final repository = _FakeDepositRepository();
        var refreshCount = 0;
        final controller = AdminWalletDepositController(repository, () async {
          refreshCount++;
        });

        final first = controller.deposit(request);
        final duplicate = await controller.deposit(request);
        expect(duplicate, isNull);
        expect(repository.calls, 1);

        repository.gate.complete();
        expect((await first)?.balanceAfter, 26000);
        expect(refreshCount, 1);
        expect(controller.state, isFalse);
      },
    );
  });

  test('parses a completed deposit credit ledger transaction', () {
    final transaction = WalletTransaction.fromJson({
      'id': 'transaction-1',
      'wallet_user_id': 'client-1',
      'counterparty_user_id': 'admin-1',
      'transaction_type': 'deposit',
      'direction': 'credit',
      'amount': '25000',
      'balance_before': '1000',
      'balance_after': '26000',
      'status': 'completed',
      'currency': 'USD',
      'title': 'Manual wallet top-up',
      'metadata': {'external_reference': 'receipt-42'},
    });

    expect(transaction.transactionType, 'deposit');
    expect(transaction.direction, 'credit');
    expect(transaction.paymentId, isNull);
    expect(transaction.referenceNumber, 'receipt-42');
    expect(transaction.currency, 'USD');
  });

  test('Dashboard financial formatting uses USD without changing value', () {
    expect(dashboardAmount(1250.75), r'$1250.75 USD');
  });
}

Future<void> _pumpWallet(
  WidgetTester tester, {
  required Future<bool> Function(Uri uri) launcher,
  String supportNumber = '+963 944-123-456',
}) async {
  const data = WalletData(
    wallet: WalletAccount(userId: 'client-1', balance: 1000),
    walletExists: true,
    transactions: [],
    profile: WalletClientProfile(
      userId: 'client-1',
      fullName: 'Client Name',
      phone: '0999999999',
    ),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [walletProvider.overrideWith((ref) async => data)],
      child: MaterialApp(
        home: WalletScreen(
          supportNumberOverride: supportNumber,
          topUpLauncher: launcher,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _FakeDepositRepository implements AdminWalletDepositRepository {
  final gate = Completer<void>();
  int calls = 0;

  @override
  Future<AdminWalletDepositResult> deposit(
    AdminWalletDepositRequest request,
  ) async {
    calls++;
    await gate.future;
    return AdminWalletDepositResult.fromJson({
      'success': true,
      'idempotent': false,
      'transaction_id': 'transaction-1',
      'transfer_group': 'group-1',
      'user_id': request.userId,
      'amount': request.amount,
      'currency': 'USD',
      'balance_before': 1000,
      'balance_after': 26000,
      'external_reference': request.reference,
      'created_at': '2026-08-06T10:00:00Z',
    });
  }

  @override
  Future<double> getBalance(String userId) async => 1000;
}
