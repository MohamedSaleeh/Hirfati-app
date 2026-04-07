import '../models/worker_profile_model.dart';

abstract class WorkerProfileRepository {
  Future<WorkerProfileModel> getWorkerProfile(String userId);
  Future<int> getCompletedJobsCount(String workerId);
  Future<int> getTotalWorkingHours(String workerId);
}