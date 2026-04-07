import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

@freezed
abstract class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    required String id,
    required String userId,
    @Default(true) bool pushEnabled,
    @Default(true) bool emailEnabled,
    @Default(false) bool smsEnabled,
    @Default(true) bool orderConfirmation,
    @Default(true) bool orderStatus,
    @Default(true) bool promotions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);
}