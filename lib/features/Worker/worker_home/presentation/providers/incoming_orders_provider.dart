import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/worker_home_providers.dart';
import '../../domain/models/worker_order.dart';
import '../../domain/repositories/worker_home_repository.dart';

final incomingOrdersProvider = FutureProvider<List<WorkerOrder>>((ref) async {
  final repo = ref.watch(workerHomeRepositoryProvider);
  return repo.getIncomingOrders();
});

class IncomingOrdersActions {
  final WorkerHomeRepository _repo;

  IncomingOrdersActions(this._repo);

  Future<void> acceptOrder(String orderId) async {
    await _repo.changeOrderStatus(orderId, 'accepted');
  }

  Future<void> rejectOrder(String orderId) async {
    await _repo.changeOrderStatus(orderId, 'rejected');
  }

  Future<void> startOrder(String orderId) async {
    await _repo.changeOrderStatus(orderId, 'in_progress');
  }

  Future<void> completeOrder(String orderId) async {
    await _repo.changeOrderStatus(orderId, 'completed');
  }

  Future<void> changeOrderStatus(String orderId, String status) async {
    await _repo.changeOrderStatus(orderId, status);
  }
}

final incomingOrdersActionsProvider = Provider<IncomingOrdersActions>((ref) {
  final repo = ref.watch(workerHomeRepositoryProvider);
  return IncomingOrdersActions(repo);
});
