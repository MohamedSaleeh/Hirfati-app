
import '../../domain/models/payment_method_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/payment_methods_repository.dart';
import '../datasources/payment_methods_supabase_datasource.dart';

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  final PaymentMethodsSupabaseDatasource _datasource;

  PaymentMethodsRepositoryImpl(this._datasource);

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods(String userId) async {
    return await _datasource.getPaymentMethods(userId);
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod(String userId, PaymentMethodModel method) async {
    return await _datasource.addPaymentMethod(userId, method);
  }

  @override
  Future<PaymentMethodModel> updatePaymentMethod(PaymentMethodModel method) async {
    return await _datasource.updatePaymentMethod(method);
  }

  @override
  Future<void> deletePaymentMethod(String methodId) async {
    await _datasource.deletePaymentMethod(methodId);
  }

  @override
  Future<void> setDefaultPaymentMethod(String userId, String methodId) async {
    await _datasource.setDefaultPaymentMethod(userId, methodId);
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions(String userId, {int limit = 5}) async {
    return await _datasource.getRecentTransactions(userId, limit: limit);
  }
}