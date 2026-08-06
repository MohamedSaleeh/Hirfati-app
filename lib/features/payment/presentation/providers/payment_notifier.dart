import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/models/order.dart';
import '../../domain/models/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import 'payment_providers.dart';

class PaymentNotifier extends StateNotifier<AsyncValue<bool>> {
  final PaymentRepository _paymentRepository;
  bool _inProgress = false;

  PaymentNotifier(this._paymentRepository) : super(const AsyncData(false));

  Future<PaymentSettlementResult?> processPayment({
    required Order order,
    required String paymentMethod,
    required String idempotencyKey,
    Map<String, dynamic>? cardDetails,
  }) async {
    if (_inProgress) return null;
    if (paymentMethod != 'wallet') {
      state = AsyncError(
        const PaymentException(
          'unsupported_payment_method',
          'This payment method is not available',
        ),
        StackTrace.current,
      );
      return null;
    }

    _inProgress = true;
    state = const AsyncLoading();
    try {
      final result = await _paymentRepository.processWalletPayment(
        order.id,
        idempotencyKey,
      );
      state = AsyncData(result.success || result.idempotent);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    } finally {
      _inProgress = false;
    }
  }

  void reset() {
    state = const AsyncData(false);
  }
}

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, AsyncValue<bool>>((ref) {
      final paymentRepository = ref.watch(paymentRepositoryProvider);
      return PaymentNotifier(paymentRepository);
    });
