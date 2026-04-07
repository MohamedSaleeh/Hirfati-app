import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile_model.freezed.dart';
part 'worker_profile_model.g.dart';

@freezed
abstract class WorkerProfileModel with _$WorkerProfileModel {
  const factory WorkerProfileModel({
    required String id,
    required String userId,
    required String fullName,
    String? avatarUrl,
    @Default('worker') String role,
    String? profession,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(0) int completedJobs,
    @Default(0) int totalHours,
    @Default(false) bool isVerified,  
    @Default(false) bool isAvailable,
    String? bio,
    @Default(0.0) double priceMin,
    @Default(0.0) double priceMax,
  }) = _WorkerProfileModel;

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileModelFromJson(json);
}