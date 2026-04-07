import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/payment_repository.dart';
import '../../domain/models/payment.dart';
import '../datasources/payment_supabase_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentSupabaseDatasource _datasource;

  PaymentRepositoryImpl(this._datasource);

  @override
  Future<Payment> createPayment({
    required String orderId,
    required double amount,
    required String userId,
    String? paymentMethod,
  }) async {
    return await _datasource.createPayment(
      orderId: orderId,
      amount: amount,
      userId: userId,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<Payment> updatePaymentStatus(
    String paymentId,
    PaymentTransactionStatus status, {
    String? transactionId,
  }) async {
    return await _datasource.updatePaymentStatus(
      paymentId,
      status,
      transactionId: transactionId,
    );
  }

  @override
  Future<Payment?> getPaymentByOrderId(String orderId) async {
    return await _datasource.getPaymentByOrderId(orderId);
  }

  @override
  Future<List<Payment>> getUserPayments(String userId) async {
    return await _datasource.getUserPayments(userId);
  }

  @override
  Future<bool> processCashPayment(String orderId, double amount) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print('❌ User not authenticated');
        return false;
      }

      print('💰 Processing cash payment for order: $orderId');
      print('   - Amount: $amount');
      print('   - UserId: $userId');

      final payment = await _datasource.createPayment(
        orderId: orderId,
        amount: amount,
        userId: userId,
        paymentMethod: 'cash',
      );

      await _datasource.updatePaymentStatus(
        payment.id,
        PaymentTransactionStatus.completed,
      );

      print('✅ Cash payment recorded successfully');
      return true;
    } catch (e) {
      print('❌ Error processing cash payment: $e');
      return false;
    }
  }

  @override
  Future<bool> processCardPayment(
    String orderId,
    double amount,
    Map<String, dynamic> cardDetails,
  ) async {
    try {
      // ✅ جلب userId الحالي
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print('❌ User not authenticated');
        return false;
      }

      print('💳 Processing card payment for order: $orderId');
      print('   - Amount: $amount');
      print('   - UserId: $userId');

      // إنشاء سجل دفع
      final payment = await _datasource.createPayment(
        orderId: orderId,
        amount: amount,
        userId: userId, // ✅ تمرير userId الصحيح
        paymentMethod: 'card',
      );

      // تحديث الحالة إلى processing
      await _datasource.updatePaymentStatus(
        payment.id,
        PaymentTransactionStatus.processing,
      );

      // محاكاة معالجة الدفع
      await Future.delayed(const Duration(seconds: 2));

      // محاكاة نجاح الدفع
      final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
      await _datasource.updatePaymentStatus(
        payment.id,
        PaymentTransactionStatus.completed,
        transactionId: transactionId,
      );

      print('✅ Card payment processed successfully');
      return true;
    } catch (e) {
      print('❌ Error processing card payment: $e');
      return false;
    }
  }

  @override
  Future<bool> processWalletPayment(String orderId, double amount) async {
    try {
      // ✅ جلب userId الحالي
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print('❌ User not authenticated');
        return false;
      }

      print('👛 Processing wallet payment for order: $orderId');
      print('   - Amount: $amount');
      print('   - UserId: $userId');

      final payment = await _datasource.createPayment(
        orderId: orderId,
        amount: amount,
        userId: userId, 
        paymentMethod: 'wallet',
      );

      await _datasource.updatePaymentStatus(
        payment.id,
        PaymentTransactionStatus.completed,
      );

      print('✅ Wallet payment processed successfully');
      return true;
    } catch (e) {
      print('❌ Error processing wallet payment: $e');
      return false;
    }
  }
}
