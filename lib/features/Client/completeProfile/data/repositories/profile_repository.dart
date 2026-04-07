abstract class ProfileRepository {
  /// Uploads avatar (if provided) and updates the profiles table in Supabase.
  /// Sets is_profile_completed = true on success.
  Future<void> completeProfile({
    required String? avatarLocalPath,
    required String city,
    required double? latitude,
    required double? longitude,
  });
  Future<bool> isProfileCompletedForUser();
  Future<bool> isProfileCompleted();
  Future<void> setOnboardingCompleted(bool completed);
}
