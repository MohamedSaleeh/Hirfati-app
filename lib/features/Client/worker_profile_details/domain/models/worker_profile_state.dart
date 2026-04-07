import 'package:freezed_annotation/freezed_annotation.dart';

import 'worker_profile_details_model.dart';
import 'worker_profile_portfolio_model.dart';
import 'worker_profile_review_model.dart';
import 'worker_profile_service_model.dart';

part 'worker_profile_state.freezed.dart';

@freezed
abstract class WorkerProfileState with _$WorkerProfileState {
  const factory WorkerProfileState({
    @Default(false) bool isLoading,
    String? errorMessage,
    WorkerProfileDetailsModel? details,
    @Default([]) List<WorkerProfilePortfolioModel> portfolio,
    @Default([]) List<WorkerProfileServiceModel> services,
    @Default([]) List<WorkerProfileReviewModel> reviews,
  }) = _WorkerProfileState;
}