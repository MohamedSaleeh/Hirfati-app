import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_settings_model.freezed.dart';
part 'account_settings_model.g.dart';

@freezed
abstract class AccountSettingsModel with _$AccountSettingsModel {
  const factory AccountSettingsModel({
    required String id,
    required String userId,
    required String fullName,
    String? phone,
    String? email,
    String? avatarUrl,
    String? city,
    int? experienceYears,
    String? bio,
  }) = _AccountSettingsModel;

  factory AccountSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AccountSettingsModelFromJson(json);
}