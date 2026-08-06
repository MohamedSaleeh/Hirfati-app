import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/core/models/order.dart';
import 'package:hirfati/features/payment/data/datasources/payment_supabase_datasource.dart';
import 'package:hirfati/features/payment/domain/models/payment.dart';
import 'package:hirfati/features/payment/domain/repositories/payment_repository.dart';
import 'package:hirfati/features/payment/presentation/providers/payment_notifier.dart';

void main() {
  test('maps exact wallet settlement RPC parameters', () {
    expect(
      PaymentSupabaseDatasource.settlementParameters(
        orderId: 'order-1',
        idempotencyKey: 'attempt-1',
      ),
      {
        'p_order_id': 'order-1',
        'p_payment_method': 'wallet',
        'p_idempotency_key': 'attempt-1',
        'p_provider_transaction_id': null,
        'p_provider': 'wallet',
      },
    );
  });

  test('parses nullable authoritative settlement response', () {
    final result = PaymentSettlementResult.fromJson({
      'success': true,
      'idempotent': true,
      'payment_id': 'payment-1',
      'order_id': 'order-1',
      'payment_status': 'completed',
      'order_payment_status': 'paid',
      'transaction_id': null,
      'reference_number': null,
      'paid_at': null,
    });

    expect(result.success, isTrue);
    expect(result.idempotent, isTrue);
    expect(result.paymentId, 'payment-1');
    expect(result.transactionId, isNull);
    expect(result.paidAt, isNull);
  });

  test('maps insufficient wallet balance without exposing raw errors', () {
    final error = PaymentSupabaseDatasource.mapPaymentError(
      Exception('insufficient_wallet_balance internal database details'),
    );

    expect(error.code, 'insufficient_wallet_balance');
    expect(error.message, 'Insufficient wallet balance');
    expect(error.message, isNot(contains('database')));
  });

  test(
    'prevents a duplicate request while settlement is in progress',
    () async {
      final repository = _PendingPaymentRepository();
      final notifier = PaymentNotifier(repository);
      final order = _order();

      final first = notifier.processPayment(
        order: order,
        paymentMethod: 'wallet',
        idempotencyKey: 'attempt-1',
      );
      final duplicate = await notifier.processPayment(
        order: order,
        paymentMethod: 'wallet',
        idempotencyKey: 'attempt-1',
      );

      expect(duplicate, isNull);
      expect(repository.callCount, 1);

      repository.completer.complete(_successResult);
      expect(await first, _successResult);
    },
  );
}

const _successResult = PaymentSettlementResult(
  success: true,
  idempotent: false,
);

class _PendingPaymentRepository implements PaymentRepository {
  final completer = Completer<PaymentSettlementResult>();
  int callCount = 0;

  @override
  Future<Payment?> getPaymentByOrderId(String orderId) async => null;

  @override
  Future<PaymentSettlementResult> processWalletPayment(
    String orderId,
    String idempotencyKey,
  ) {
    callCount++;
    return completer.future;
  }
}

Order _order() {
  return Order(
    id: 'order-1',
    clientId: 'client-1',
    clientName: 'Client',
    workerId: 'worker-1',
    workerName: 'Worker',
    serviceTitle: 'Service',
    price: 2500,
    status: OrderStatus.completed,
    paymentStatus: PaymentStatus.pending,
    requestType: OrderRequestType.scheduled,
    address: 'Address',
    distance: 0,
    createdAt: DateTime(2026),
  );
}
