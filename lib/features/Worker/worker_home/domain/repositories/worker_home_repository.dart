import '../models/worker_dashboard_data.dart';
import '../models/worker_order.dart';

abstract class WorkerHomeRepository {
  Future<WorkerDashboardData> getDashboard();
  Future<List<WorkerOrder>> getIncomingOrders();
  Future<List<WorkerOrder>> getActiveJobs();
  Future<bool> getAvailability();
  Future<void> setAvailability(bool value);
  Future<void> changeOrderStatus(String orderId, String status);
}