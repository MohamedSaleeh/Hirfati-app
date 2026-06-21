import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile_model.freezed.dart';
part 'worker_profile_model.g.dart';

@freezed
abstract class WorkerProfileModel with _$WorkerProfileModel {
  const factory WorkerProfileModel({
    required String categoryId,
    required int experienceYears,
    required String bio,
    required double priceMin,
    required double priceMax,
    required bool isAvailable,
    required double latitude,
    required double longitude,
  }) = _WorkerProfileModel;

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileModelFromJson(json);
}
