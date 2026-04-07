import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_model.freezed.dart';
part 'pin_model.g.dart';

enum PinAction {
  create,
  verify,
  change,
  reset,
}

@freezed
abstract class PinModel with _$PinModel {
  const factory PinModel({
    required String userId,
    required String pin,
    @Default(false) bool isSet,
    @Default(0) int attempts,
    DateTime? lastAttemptAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PinModel;

  factory PinModel.fromJson(Map<String, dynamic> json) =>
      _$PinModelFromJson(json);
}