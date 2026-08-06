import '../../domain/repositories/admin_users_repository.dart';
import '../../models/admin_users_models.dart';
import '../../models/dashboard_models.dart';
import '../datasources/admin_users_datasource.dart';

class AdminUsersRepositoryImpl implements AdminUsersRepository {
  AdminUsersRepositoryImpl(this._datasource);

  final AdminUsersDatasource _datasource;

  @override
  Future<AdminUsersPageData> loadUsers(AdminUsersQuery query) async {
    final result = await _datasource.loadUsers(query);
    return AdminUsersPageData(
      users: result.rows.map(_mapUser).toList(),
      totalUsers: result.count,
    );
  }

  @override
  Future<void> setActiveStatus({
    required String userId,
    required bool isActive,
  }) {
    return _datasource.setActiveStatus(userId: userId, isActive: isActive);
  }

  DashboardUser _mapUser(Map<String, dynamic> row) {
    String? optionalText(Object? value) {
      final text = value?.toString().trim();
      return text == null || text.isEmpty ? null : text;
    }

    final createdAt = DateTime.tryParse(row['created_at']?.toString() ?? '');
    final updatedAt = DateTime.tryParse(row['updated_at']?.toString() ?? '');
    final role = switch (row['role']?.toString()) {
      'admin' => UserDashboardRole.admin,
      'worker' => UserDashboardRole.craftsman,
      _ => UserDashboardRole.client,
    };
    return DashboardUser(
      id: row['id']?.toString() ?? '',
      name: optionalText(row['full_name']) ?? 'مستخدم بدون اسم',
      phone: optionalText(row['phone']) ?? 'غير متوفر',
      role: role,
      status: row['is_active'] == false
          ? UserDashboardStatus.suspended
          : UserDashboardStatus.active,
      lastSeenLabel: _dateLabel(updatedAt ?? createdAt),
      avatarUrl: optionalText(row['avatar_url']),
      city: optionalText(row['city']),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return 'غير متوفر';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
