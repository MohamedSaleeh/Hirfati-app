import 'package:hirfati/features/Client/completeProfile/data/datasources/profile_remote_datasource.dart';
import 'package:hirfati/features/Client/completeProfile/data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _datasource;

  ProfileRepositoryImpl(this._datasource);

  @override
  Future<void> completeProfile({
    required String? avatarLocalPath,
    required String city,
    required double? latitude,
    required double? longitude,
  }) async {
    String? avatarUrl;

    if (avatarLocalPath != null && avatarLocalPath.isNotEmpty) {
      avatarUrl = await _datasource.uploadAvatar(avatarLocalPath);
    }

    await _datasource.updateProfile(
      avatarUrl: avatarUrl,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<bool> isProfileCompletedForUser() async {
    return await _datasource.isProfileCompletedForUser();
  }

  @override
  Future<bool> isProfileCompleted() async {
    final completed = await _datasource.isProfileCompleted();
    return completed;
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await _datasource.setOnboardingCompleted(completed);
  }
}
