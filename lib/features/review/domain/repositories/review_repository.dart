import '../models/review_model.dart';

abstract class ReviewRepository {
  Future<ReviewModel> createReview({
    required String orderId,
    required String workerId,
    required String clientId,
    required int rating,
    required String comment,
  });
  
  Future<ReviewModel?> getReviewByOrderId(String orderId);
  Future<List<ReviewModel>> getWorkerReviews(String workerId);
  Future<double> getWorkerAverageRating(String workerId);
  Future<bool> hasReviewed(String orderId);
}