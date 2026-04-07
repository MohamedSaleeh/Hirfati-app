import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_setup_state.freezed.dart';

@freezed
abstract class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState({
    /// Local file path of the image chosen by the user (before upload)
    String? avatarLocalPath,

    /// Remote URL returned after uploading to Supabase Storage
    String? avatarUrl,

    @Default('') String city,

    double? latitude,
    double? longitude,

    @Default(false) bool isLoading,

    @Default(false) bool isProfileCompleted,
    @Default(false) bool hasCompletedOnboarding,

    String? errorMessage,
  }) = _ProfileSetupState;
}
