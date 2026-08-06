import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/admin_users_models.dart';
import '../../models/dashboard_models.dart';

class AdminUsersDatasource {
  AdminUsersDatasource(this._client);

  final SupabaseClient _client;

  static ({int start, int end}) rangeFor(AdminUsersQuery query) {
    return (start: query.start, end: query.end);
  }

  Future<({List<Map<String, dynamic>> rows, int count})> loadUsers(
    AdminUsersQuery query,
  ) async {
    dynamic request = _client
        .from('profiles')
        .select(
          'id, full_name, phone, role, city, is_active, avatar_url, '
          'created_at, updated_at',
        );
    request = _applyFilters(request, query);
    final response = await request
        .order('created_at', ascending: false)
        .range(query.start, query.end)
        .count(CountOption.exact);
    final rows = (response.data as List<dynamic>)
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
    return (rows: rows, count: response.count as int);
  }

  dynamic _applyFilters(dynamic request, AdminUsersQuery query) {
    final search = query.search
        .trim()
        .replaceAll(RegExp(r'[%(),]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (search.isNotEmpty) {
      request = request.or(
        'full_name.ilike.%$search%,phone.ilike.%$search%,city.ilike.%$search%',
      );
    }
    if (query.role != null) {
      final role = switch (query.role!) {
        UserDashboardRole.client => 'client',
        UserDashboardRole.craftsman => 'worker',
        UserDashboardRole.admin => 'admin',
      };
      request = request.eq('role', role);
    }
    if (query.status != null) {
      request = request.eq(
        'is_active',
        query.status != UserDashboardStatus.suspended,
      );
    }
    return request;
  }

  static Map<String, dynamic> statusParameters({
    required String userId,
    required bool isActive,
  }) {
    return {'p_user_id': userId, 'p_is_active': isActive};
  }

  Future<void> setActiveStatus({
    required String userId,
    required bool isActive,
  }) async {
    await _client.rpc(
      'set_user_active_status',
      params: statusParameters(userId: userId, isActive: isActive),
    );
  }
}
