import '../../domain/models/client_profile.dart';
import '../../domain/repositories/client_profile_repository.dart';
import '../datasources/client_profile_supabase_datasource.dart';

class ClientProfileRepositoryImpl implements ClientProfileRepository {
  final ClientProfileSupabaseDatasource _datasource;

  ClientProfileRepositoryImpl(this._datasource);

  @override
  Future<ClientProfile> getProfile(String userId) async {
    return await _datasource.getProfile(userId);
  }

  @override
  Future<ClientProfile> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
  }) async {
    return await _datasource.updateProfile(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required String imagePath,
  }) async {
    final avatarUrl = await _datasource.uploadAvatar(
      userId: userId,
      imagePath: imagePath,
    );
    
    await _datasource.updateAvatarUrl(
      userId: userId,
      avatarUrl: avatarUrl,
    );
    
    return avatarUrl;
  }

  @override
  Future<void> updateAvatarUrl({
    required String userId,
    required String avatarUrl,
  }) async {
    await _datasource.updateAvatarUrl(
      userId: userId,
      avatarUrl: avatarUrl,
    );
  }
}