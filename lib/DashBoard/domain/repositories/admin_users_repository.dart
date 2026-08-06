import '../../models/admin_users_models.dart';

abstract class AdminUsersRepository {
  Future<AdminUsersPageData> loadUsers(AdminUsersQuery query);

  Future<void> setActiveStatus({
    required String userId,
    required bool isActive,
  });
}
