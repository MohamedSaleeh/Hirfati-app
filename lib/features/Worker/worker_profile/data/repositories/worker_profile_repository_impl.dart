import '../../domain/models/worker_profile_model.dart';
import '../../domain/repositories/worker_profile_repository.dart';
import '../datasources/worker_profile_supabase_datasource.dart';

class WorkerProfileRepositoryImpl implements WorkerProfileRepository {
  final WorkerProfileSupabaseDatasource _datasource;

  WorkerProfileRepositoryImpl(this._datasource);

  @override
  Future<WorkerProfileModel> getWorkerProfile(String userId) async {
    return await _datasource.getWorkerProfile(userId);
  }

  @override
  Future<int> getCompletedJobsCount(String workerId) async {
    return await _datasource.getCompletedJobsCount(workerId);
  }

  @override
  Future<int> getTotalWorkingHours(String workerId) async {
    return await _datasource.getTotalWorkingHours(workerId);
  }
}