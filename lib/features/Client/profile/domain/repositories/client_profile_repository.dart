import '../models/client_profile.dart';

abstract class ClientProfileRepository {
  Future<ClientProfile> getProfile(String userId);
  Future<ClientProfile> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
  });
  Future<String> uploadAvatar({
    required String userId,
    required String imagePath,
  });
  Future<void> updateAvatarUrl({
    required String userId,
    required String avatarUrl,
  });
}