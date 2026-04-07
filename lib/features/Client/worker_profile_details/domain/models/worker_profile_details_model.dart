import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile_details_model.freezed.dart';
part 'worker_profile_details_model.g.dart';

@freezed
abstract class WorkerProfileDetailsModel with _$WorkerProfileDetailsModel {
  const factory WorkerProfileDetailsModel({
    required String workerId,
    required String userId,
    required String fullName,
    required String? avatarUrl,
    required String? city,
    required String categoryName,
    required String? categoryIcon,
    required int experienceYears,
    required String bio,
    required double priceMin,
    required double priceMax,
    required double ratingAverage,
    required int ratingCount,
    required int completedJobsCount,
    required bool approved,
    required bool profileCompleted,
    required bool isFavorite,
  }) = _WorkerProfileDetailsModel;

  factory WorkerProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileDetailsModelFromJson(json);
}