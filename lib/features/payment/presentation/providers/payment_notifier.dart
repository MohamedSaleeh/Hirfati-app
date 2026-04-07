// lib/features/payment/presentation/providers/payment_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/order.dart';
import '../../domain/repositories/payment_repository.dart';
import '../providers/payment_providers.dart';
import '../../../Client/orders/data/datasources/orders_supabase_datasource.dart';

class PaymentNotifier extends StateNotifier<AsyncValue<bool>> {
  final PaymentRepository _paymentRepository;
  final OrdersSupabaseDatasource _ordersDatasource;

  PaymentNotifier(this._paymentRepository, this._ordersDatasource)
    : super(const AsyncData(false));

  Future<bool> processPayment({
    required Order order,
    required String paymentMethod,
    Map<String, dynamic>? cardDetails,
  }) async {
    state = const AsyncLoading();

    print('💰 Processing payment:');
    print('   - Order ID: ${order.id}');
    print('   - Amount: ${order.price}');
    print('   - Method: $paymentMethod');

    // تحقق من وجود الطلب
    final orderCheck = await _ordersDatasource.getOrderById(order.id);
    print('   - Order exists: ${orderCheck != null}');
    if (orderCheck != null) {
      print('   - Order price from DB: ${orderCheck.price}');
      print('   - Order status: ${orderCheck.status}');
      print('   - Order payment status: ${orderCheck.paymentStatus}');
    }
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

      if (success) {
        // ✅ تحديث حالة الدفع مباشرة باستخدام Datasource
        await _ordersDatasource.updatePaymentStatus(
          order.id,
          PaymentStatus.paid,
          paymentMethod: paymentMethod,
          transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        );

        state = const AsyncData(true);
        return true;
      }

      state = const AsyncData(false);
      return false;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  void reset() {
    state = const AsyncData(false);
  }
}

final ordersDatasourceProvider = Provider<OrdersSupabaseDatasource>((ref) {
  final supabase = Supabase.instance.client;
  return OrdersSupabaseDatasource(supabase);
});

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, AsyncValue<bool>>((ref) {
      final paymentRepository = ref.watch(paymentRepositoryProvider);
      final ordersDatasource = ref.watch(ordersDatasourceProvider);
      return PaymentNotifier(paymentRepository, ordersDatasource);
    });
