import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/payment_methods_providers.dart';
import '../../domain/models/payment_method_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/payment_methods_repository.dart';


class PaymentMethodsNotifier extends StateNotifier<AsyncValue<List<PaymentMethodModel>>> {
  final PaymentMethodsRepository _repository;
  final String _userId;

  PaymentMethodsNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadPaymentMethods() async {
    state = const AsyncLoading();
    try {
      final methods = await _repository.getPaymentMethods(_userId);
      state = AsyncData(methods);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addPaymentMethod(PaymentMethodModel method) async {
    state.whenData((currentMethods) async {
      try {
        state = const AsyncLoading();
        final newMethod = await _repository.addPaymentMethod(_userId, method);
        state = AsyncData([...currentMethods, newMethod]);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> deletePaymentMethod(String methodId) async {
    state.whenData((currentMethods) async {
      try {
        state = const AsyncLoading();
        await _repository.deletePaymentMethod(methodId);
        final updatedList = currentMethods.where((m) => m.id != methodId).toList();
        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> setDefaultPaymentMethod(String methodId) async {
    state.whenData((currentMethods) async {
      try {
        state = const AsyncLoading();
        await _repository.setDefaultPaymentMethod(_userId, methodId);
        final updatedList = currentMethods.map((method) {
          return method.copyWith(isDefault: method.id == methodId);
        }).toList();
        state = AsyncData(updatedList);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }
}

final paymentMethodsProvider = StateNotifierProvider<PaymentMethodsNotifier, AsyncValue<List<PaymentMethodModel>>>((ref) {
  final repository = ref.watch(paymentMethodsRepositoryProvider);
  final user = ref.watch(supabaseClientProvider).auth.currentUser;
  
  if (user == null) throw Exception('User not authenticated');
  
  final notifier = PaymentMethodsNotifier(repository, user.id);
  notifier.loadPaymentMethods();
  return notifier;
});

// Provider للمعاملات الأخيرة
final recentTransactionsProvider = FutureProvider<List<TransactionModel>>((ref) {
  final repository = ref.watch(paymentMethodsRepositoryProvider);
  final user = ref.watch(supabaseClientProvider).auth.currentUser;
  
  if (user == null) throw Exception('User not authenticated');
  
  return repository.getRecentTransactions(user.id, limit: 5);
});