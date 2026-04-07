import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile_review_model.freezed.dart';
part 'worker_profile_review_model.g.dart';

@freezed
abstract class WorkerProfileReviewModel with _$WorkerProfileReviewModel {
  const factory WorkerProfileReviewModel({
    required String id,
    required String clientId,
    required String clientName,
    required String? clientAvatarUrl,
    required double rating,
    required String comment,
    required DateTime createdAt,
  }) = _WorkerProfileReviewModel;

  factory WorkerProfileReviewModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileReviewModelFromJson(json);
}