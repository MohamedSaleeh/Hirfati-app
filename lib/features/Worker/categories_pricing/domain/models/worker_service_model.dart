import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_service_model.freezed.dart';
part 'worker_service_model.g.dart';

@freezed
abstract class WorkerServiceModel with _$WorkerServiceModel {
  const factory WorkerServiceModel({
    required String id,
    required String title,
    String? description,
    required double price,
    int? durationMinutes,
  }) = _WorkerServiceModel;

  factory WorkerServiceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerServiceModelFromJson(json);
}