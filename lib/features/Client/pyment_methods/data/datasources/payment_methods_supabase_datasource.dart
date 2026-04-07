import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/payment_method_model.dart';
import '../../domain/models/transaction_model.dart';

class PaymentMethodsSupabaseDatasource {
  final SupabaseClient _client;

  PaymentMethodsSupabaseDatasource(this._client);

  // بيانات تجريبية (mock data)
  Future<List<PaymentMethodModel>> getPaymentMethods(String userId) async {
    // في المستقبل: return await _client.from('payment_methods').select().eq('user_id', userId);
    
    // حالياً: بيانات تجريبية
    return [
      PaymentMethodModel(
        id: '1',
        cardType: CardType.visa,
        last4: '4242',
        expiryMonth: '12',
        expiryYear: '26',
        isDefault: true,
        cardholderName: 'Mohamed Ahmed',
      ),
      PaymentMethodModel(
        id: '2',
        cardType: CardType.mastercard,
        last4: '8819',
        expiryMonth: '08',
        expiryYear: '25',
        isDefault: false,
        cardholderName: 'Mohamed Ahmed',
      ),
    ];
  }

  Future<PaymentMethodModel> addPaymentMethod(String userId, PaymentMethodModel method) async {
    // محاكاة الإضافة
    await Future.delayed(const Duration(milliseconds: 500));
    return method.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
  }

  Future<PaymentMethodModel> updatePaymentMethod(PaymentMethodModel method) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return method;
  }

  Future<void> deletePaymentMethod(String methodId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> setDefaultPaymentMethod(String userId, String methodId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<TransactionModel>> getRecentTransactions(String userId, {int limit = 5}) async {
    // بيانات تجريبية للمعاملات
    return [
      TransactionModel(
        id: '1',
        title: 'Kitchen Sink Repair',
        date: DateTime(2024, 5, 12),
        category: 'Plumbing',
        price: 85.00,
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: '2',
        title: 'Bookshelf Assembly',
        date: DateTime(2024, 5, 8),
        category: 'Carpentry',
        price: 120.00,
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: '3',
        title: 'Light Fixture Install',
        date: DateTime(2024, 5, 2),
        category: 'Electrical',
        price: 45.50,
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: '4',
        title: 'AC Maintenance',
        date: DateTime(2024, 4, 28),
        category: 'Air Conditioning',
        price: 150.00,
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: '5',
        title: 'Wall Painting',
        date: DateTime(2024, 4, 20),
        category: 'Painting',
        price: 280.00,
        status: TransactionStatus.completed,
      ),
    ].take(limit).toList();
  }
}