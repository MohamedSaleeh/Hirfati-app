import '../models/account_settings_model.dart';

abstract class AccountSettingsRepository {
  Future<AccountSettingsModel> getSettings(String userId);
  Future<AccountSettingsModel> updateSettings({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? city,
    int? experienceYears,
    String? bio,
  });
  Future<String?> uploadAvatar(String userId, String imagePath);
}