import '../../domain/repositories/admin_verification_repository.dart';
import '../../models/dashboard_models.dart';
import '../datasources/admin_verification_datasource.dart';

class AdminVerificationRepositoryImpl implements AdminVerificationRepository {
  AdminVerificationRepositoryImpl(this._datasource);

  final AdminVerificationDatasource _datasource;

  @override
  Future<List<DashboardVerificationRequest>> loadPendingRequests() async {
    final rows = await _datasource.loadPendingRequests();
    final userIds = rows
        .map((row) => row['user_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();
    final profiles = await _datasource.loadProfiles(userIds);
    final profilesById = {
      for (final profile in profiles)
        if (profile['id'] != null) profile['id'].toString(): profile,
    };
    return rows
        .map(
          (row) => DashboardVerificationRequest.fromJson(
            row,
            profile: profilesById[row['user_id']?.toString()],
          ),
        )
        .toList();
  }

  @override
  Future<void> processRequest({
    required String requestId,
    required bool approve,
    String? rejectionReason,
  }) {
    return _datasource.processRequest(
      requestId: requestId,
      approve: approve,
      rejectionReason: rejectionReason,
    );
  }
}
