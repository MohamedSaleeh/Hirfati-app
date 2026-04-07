import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile_service_model.freezed.dart';
part 'worker_profile_service_model.g.dart';

@freezed
abstract class WorkerProfileServiceModel with _$WorkerProfileServiceModel {
  const factory WorkerProfileServiceModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required int durationMinutes,
  }) = _WorkerProfileServiceModel;

  factory WorkerProfileServiceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileServiceModelFromJson(json);
}