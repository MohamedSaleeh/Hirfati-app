import 'package:freezed_annotation/freezed_annotation.dart';

part 'workersetupstate_model.freezed.dart';
part 'workersetupstate_model.g.dart';

@freezed
abstract class WorkerSetupState with _$WorkerSetupState {
  const factory WorkerSetupState({
    @Default('') String categoryId,
    @Default(0) int experienceYears,
    @Default('') String bio,
    double? priceMin,
    double? priceMax,
  }) = _WorkerSetupState;
   factory WorkerSetupState.fromJson(Map<String, dynamic> json) =>
      _$WorkerSetupStateFromJson(json);
}

