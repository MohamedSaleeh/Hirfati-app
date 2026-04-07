import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/worker_profile_details_model.dart';
import '../../domain/models/worker_profile_portfolio_model.dart';
import '../../domain/models/worker_profile_review_model.dart';
import '../../domain/models/worker_profile_service_model.dart';
import '../../domain/repositories/worker_profile_repository.dart';
import '../datasources/worker_profile_supabase_datasource.dart';

class WorkerProfileRepositoryImpl implements WorkerProfileRepository {
  final WorkerProfileSupabaseDatasource _datasource;
  final SupabaseClient _client;

  WorkerProfileRepositoryImpl(this._datasource, this._client);

  String get _currentUserId => _client.auth.currentUser!.id;

  @override
  Future<WorkerProfileDetailsModel> getWorkerDetails(String workerId) async {
    final details = await _datasource.getWorkerDetails(workerId);

    final isFav = await _datasource.isFavorite(
      clientId: _currentUserId,
      workerId: workerId,
    );

    return details.copyWith(isFavorite: isFav);
  }

  @override
  Future<List<WorkerProfilePortfolioModel>> getWorkerPortfolio(
    String workerId, {
    int limit = 4,
  }) {
    return _datasource.getWorkerPortfolio(workerId, limit: limit);
  }

  @override
  Future<List<WorkerProfileServiceModel>> getWorkerServices(String workerId) {
    return _datasource.getWorkerServices(workerId);
  }

  @override
  Future<List<WorkerProfileReviewModel>> getWorkerReviews(
    String workerId, {
    int limit = 5,
  }) {
    return _datasource.getWorkerReviews(workerId, limit: limit);
  }

  @override
  Future<bool> isFavorite(String workerId) {
    return _datasource.isFavorite(
      clientId: _currentUserId,
      workerId: workerId,
    );
  }

  @override
  Future<void> toggleFavorite(String workerId) async {
    final fav = await isFavorite(workerId);

    if (fav) {
      await _datasource.removeFavorite(
        clientId: _currentUserId,
        workerId: workerId,
      );
    } else {
      await _datasource.addFavorite(
        clientId: _currentUserId,
        workerId: workerId,
      );
    }
  }
}