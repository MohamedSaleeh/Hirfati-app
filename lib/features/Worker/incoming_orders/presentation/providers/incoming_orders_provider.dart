import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/incoming_orders_providers.dart';
import '../../domain/models/incoming_order_model.dart';
import '../../domain/repositories/incoming_orders_repository.dart';

class IncomingOrdersNotifier extends StateNotifier<AsyncValue<List<IncomingOrderModel>>> {
  final IncomingOrdersRepository _repository;
  final String _userId;

  IncomingOrdersNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadOrders() async {
    state = const AsyncLoading();
    try {
      final orders = await _repository.getIncomingOrders(_userId);
      state = AsyncData(orders);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> acceptOrder(String orderId) async {
    state.whenData((currentOrders) async {
      try {
        await _repository.acceptOrder(orderId);
        final updatedOrders = currentOrders.where((o) => o.id != orderId).toList();
        state = AsyncData(updatedOrders);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<void> rejectOrder(String orderId) async {
    state.whenData((currentOrders) async {
      try {
        await _repository.rejectOrder(orderId);
        final updatedOrders = currentOrders.where((o) => o.id != orderId).toList();
        state = AsyncData(updatedOrders);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }
}

final incomingOrdersProvider = StateNotifierProvider<IncomingOrdersNotifier, AsyncValue<List<IncomingOrderModel>>>((ref) {
  final repository = ref.watch(incomingOrdersRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  final notifier = IncomingOrdersNotifier(repository, user.id);
  notifier.loadOrders();
  return notifier;
});