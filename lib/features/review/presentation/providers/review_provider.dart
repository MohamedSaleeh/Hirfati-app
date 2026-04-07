import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/providers/review_providers.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewNotifier extends StateNotifier<AsyncValue<bool>> {
  final ReviewRepository _repository;
  final String _orderId;
  final String _workerId;
  final String _clientId;
  bool _isDisposed = false;

  ReviewNotifier(
    this._repository,
    this._orderId,
    this._workerId,
    this._clientId,
  ) : super(const AsyncData(false));

  Future<bool> submitReview({
    required int rating,
    required String comment,
  }) async {
    if (_isDisposed) {
      print('⚠️ ReviewNotifier already disposed');
      return false;
    }

    print('📝 Submitting review...');
    state = const AsyncLoading();

    try {
      await _repository.createReview(
        orderId: _orderId,
        workerId: _workerId,
        clientId: _clientId,
        rating: rating,
        comment: comment,
      );

      print('✅ Review created successfully');

      if (!_isDisposed) {
        state = const AsyncData(true);
      }
      return true;
    } catch (e, st) {
      print('❌ Error creating review: $e');
      if (!_isDisposed) {
        state = AsyncError(e, st);
      }
      return false;
    }
  }

  @override
  void dispose() {
    print('🗑️ ReviewNotifier disposed');
    _isDisposed = true;
    super.dispose();
  }
}

// ✅ لا تتحقق من الـ IDs هنا
final reviewProvider =
    StateNotifierProvider.autoDispose<ReviewNotifier, AsyncValue<bool>>((ref) {
      final repository = ref.watch(reviewRepositoryProvider);
      final orderId = ref.watch(reviewOrderIdProvider);
      final workerId = ref.watch(reviewWorkerIdProvider);
      final clientId = ref.watch(reviewClientIdProvider);

      return ReviewNotifier(
        repository,
        orderId ?? '',
        workerId ?? '',
        clientId ?? '',
      );
    });

// ✅ الـ IDs ليست autoDispose
final reviewOrderIdProvider = StateProvider<String?>((ref) => null);
final reviewWorkerIdProvider = StateProvider<String?>((ref) => null);
final reviewClientIdProvider = StateProvider<String?>((ref) => null);

final hasReviewedProvider = FutureProvider.family<bool, String>((
  ref,
  orderId,
) async {
  final repository = ref.watch(reviewRepositoryProvider);
  return await repository.hasReviewed(orderId);
});

final workerAverageRatingProvider = FutureProvider.family<double, String>((
  ref,
  workerId,
) async {
  final repository = ref.watch(reviewRepositoryProvider);
  return await repository.getWorkerAverageRating(workerId);
});
