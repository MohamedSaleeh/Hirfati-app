import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/review_model.dart';

class ReviewSupabaseDatasource {
  final SupabaseClient _client;

  ReviewSupabaseDatasource(this._client);

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

    final response = await _client
        .from('reviews')
        .insert({
          'order_id': orderId,
          'worker_id': workerId,
          'client_id': clientId,
          'rating': rating,
          'comment': comment,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    print('✅ Review created with ID: ${response['id']}');

    return ReviewModel(
      id: response['id'],
      orderId: response['order_id'],
      clientId: response['client_id'],
      workerId: response['worker_id'],
      rating: response['rating'],
      comment: response['comment'],
      createdAt: DateTime.parse(response['created_at']),
    );
  }

  Future<ReviewModel?> getReviewByOrderId(String orderId) async {
    final response = await _client
        .from('reviews')
        .select()
        .eq('order_id', orderId)
        .maybeSingle();

    if (response == null) return null;

    return ReviewModel(
      id: response['id'],
      orderId: response['order_id'],
      clientId: response['client_id'],
      workerId: response['worker_id'],
      rating: response['rating'],
      comment: response['comment'],
      createdAt: DateTime.parse(response['created_at']),
    );
  }

  Future<List<ReviewModel>> getWorkerReviews(String workerId) async {
    final response = await _client
        .from('reviews')
        .select()
        .eq('worker_id', workerId)
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (json) => ReviewModel(
            id: json['id'],
            orderId: json['order_id'],
            clientId: json['client_id'],
            workerId: json['worker_id'],
            rating: json['rating'],
            comment: json['comment'],
            createdAt: DateTime.parse(json['created_at']),
          ),
        )
        .toList();
  }

  Future<double> getWorkerAverageRating(String workerId) async {
    final response = await _client
        .rpc('get_worker_average_rating', params: {'worker_id': workerId})
        .maybeSingle();

    return (response?['average'] as num?)?.toDouble() ?? 0.0;
  }

  Future<bool> hasReviewed(String orderId) async {
    print('🗄️ hasReviewed called with orderId: $orderId');

    final response = await _client
        .from('reviews')
        .select('id')
        .eq('order_id', orderId)
        .maybeSingle();

    print('🗄️ Response: $response');
    print('🗄️ Has review: ${response != null}');

    return response != null;
  }
}
