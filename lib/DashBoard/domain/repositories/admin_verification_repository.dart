import '../../models/dashboard_models.dart';

abstract class AdminVerificationRepository {
  Future<List<DashboardVerificationRequest>> loadPendingRequests();

  Future<void> processRequest({
    required String requestId,
    required bool approve,
    String? rejectionReason,
  });
}
