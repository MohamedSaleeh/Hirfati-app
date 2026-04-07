import '../../domain/models/review_model.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_supabase_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewSupabaseDatasource _datasource;

  ReviewRepositoryImpl(this._datasource);

  @override
  Future<ReviewModel> createReview({
    required String orderId,
    required String workerId,
    required String clientId,
    required int rating,
    required String comment,
  }) async {
    print('📝 Creating review for order: $orderId');
    print('   - Worker: $workerId');
    print('   - Rating: $rating');
    print('   - Comment: $comment');

    final result = await _datasource.createReview(
      orderId: orderId,
      workerId: workerId,
      clientId: clientId,
      rating: rating,
      comment: comment,
    );

    print('✅ Review created with ID: ${result.id}');
    return result;
  }

  @override
  Future<ReviewModel?> getReviewByOrderId(String orderId) async {
    return await _datasource.getReviewByOrderId(orderId);
  }

  @override
  Future<List<ReviewModel>> getWorkerReviews(String workerId) async {
    return await _datasource.getWorkerReviews(workerId);
  }

  @override
  Future<double> getWorkerAverageRating(String workerId) async {
    return await _datasource.getWorkerAverageRating(workerId);
  }

  @override
  Future<bool> hasReviewed(String orderId) async {
    return await _datasource.hasReviewed(orderId);
  }
}
