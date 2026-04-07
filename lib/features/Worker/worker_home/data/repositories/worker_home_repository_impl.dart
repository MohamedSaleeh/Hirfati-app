
import '../../domain/models/worker_dashboard_data.dart';
import '../../domain/models/worker_order.dart';
import '../../domain/repositories/worker_home_repository.dart';
import '../datasources/worker_home_remote_datasource.dart';

class WorkerHomeRepositoryImpl implements WorkerHomeRepository {
  final WorkerHomeRemoteDatasource _remote;

  WorkerHomeRepositoryImpl(this._remote);

  @override
  Future<WorkerDashboardData> getDashboard() => _remote.fetchDashboard();

  @override
  Future<List<WorkerOrder>> getIncomingOrders() => _remote.fetchIncomingOrders();

  @override
  Future<List<WorkerOrder>> getActiveJobs() => _remote.fetchActiveJobs();

  @override
  Future<bool> getAvailability() => _remote.fetchAvailability();

  @override
  Future<void> setAvailability(bool value) => _remote.updateAvailability(value);

  @override
  Future<void> changeOrderStatus(String orderId, String status) =>
      _remote.updateOrderStatus(orderId, status);
}