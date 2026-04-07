import '../models/worker_profile_details_model.dart';
import '../models/worker_profile_portfolio_model.dart';
import '../models/worker_profile_review_model.dart';
import '../models/worker_profile_service_model.dart';

abstract class WorkerProfileRepository {
  Future<WorkerProfileDetailsModel> getWorkerDetails(String workerId);

  Future<List<WorkerProfilePortfolioModel>> getWorkerPortfolio(
    String workerId, {
    int limit = 4,
  });

  Future<List<WorkerProfileServiceModel>> getWorkerServices(String workerId);

  Future<List<WorkerProfileReviewModel>> getWorkerReviews(
    String workerId, {
    int limit = 5,
  });

  Future<bool> isFavorite(String workerId);

  Future<void> toggleFavorite(String workerId);
}