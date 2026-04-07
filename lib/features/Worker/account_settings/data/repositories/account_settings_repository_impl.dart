import '../../domain/models/account_settings_model.dart';
import '../../domain/repositories/account_settings_repository.dart';
import '../datasources/account_settings_supabase_datasource.dart';

class AccountSettingsRepositoryImpl implements AccountSettingsRepository {
  final AccountSettingsSupabaseDatasource _datasource;

  AccountSettingsRepositoryImpl(this._datasource);

  @override
  Future<AccountSettingsModel> getSettings(String userId) async {
    return await _datasource.getSettings(userId);
  }

  @override
  Future<AccountSettingsModel> updateSettings({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? city,
    int? experienceYears,
    String? bio,
  }) async {
    return await _datasource.updateSettings(
      userId: userId,
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
      city: city,
      experienceYears: experienceYears,
      bio: bio,
    );
  }

  @override
  Future<String?> uploadAvatar(String userId, String imagePath) async {
    return await _datasource.uploadAvatar(userId, imagePath);
  }
}