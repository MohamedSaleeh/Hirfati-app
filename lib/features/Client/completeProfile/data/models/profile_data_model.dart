import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_data_model.freezed.dart';
part 'profile_data_model.g.dart';

/// DTO that maps to the relevant subset of the `profiles` Supabase table
/// used during the complete-profile flow.
@freezed
abstract class ProfileDataModel with _$ProfileDataModel {
  const factory ProfileDataModel({
    required String id,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'city') String? city,
    @JsonKey(name: 'latitude') double? latitude,
    @JsonKey(name: 'longitude') double? longitude,
    @Default(false)
    @JsonKey(name: 'is_profile_completed')
    bool isProfileCompleted,
    @Default(false)
    @JsonKey(name: 'has_completed_onboarding')
    bool hasCompletedOnboarding,
  }) = _ProfileDataModel;

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataModelFromJson(json);
}
