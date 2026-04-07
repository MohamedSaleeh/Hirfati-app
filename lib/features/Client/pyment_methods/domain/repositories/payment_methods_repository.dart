import '../models/payment_method_model.dart';
import '../models/transaction_model.dart';

abstract class PaymentMethodsRepository {
  Future<List<PaymentMethodModel>> getPaymentMethods(String userId);
  Future<PaymentMethodModel> addPaymentMethod(String userId, PaymentMethodModel method);
  Future<PaymentMethodModel> updatePaymentMethod(PaymentMethodModel method);
  Future<void> deletePaymentMethod(String methodId);
  Future<void> setDefaultPaymentMethod(String userId, String methodId);
  
  Future<List<TransactionModel>> getRecentTransactions(String userId, {int limit = 5});
}