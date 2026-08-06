// lib/features/payment/presentation/providers/payment_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/models/order.dart';
import '../../domain/repositories/payment_repository.dart';
import '../providers/payment_providers.dart';

class PaymentNotifier extends StateNotifier<AsyncValue<bool>> {
  final PaymentRepository _paymentRepository;

  PaymentNotifier(this._paymentRepository) : super(const AsyncData(false));

  Future<bool> processPayment({
    required Order order,
    required String paymentMethod,
    Map<String, dynamic>? cardDetails,
  }) async {
    state = const AsyncLoading();

    try {
      bool success = false;

      switch (paymentMethod) {
        case 'cash':
          success = await _paymentRepository.processCashPayment(
            order.id,
            order.price,
          );
          break;
        case 'card':
          if (cardDetails != null) {
            success = await _paymentRepository.processCardPayment(
              order.id,
              order.price,
              cardDetails,
            );
          }
          break;
        case 'wallet':
          success = await _paymentRepository.processWalletPayment(
            order.id,
            order.price,
          );
          break;

        default:
          throw Exception('Unknown payment method');
      }

      state = AsyncData(success);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
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
