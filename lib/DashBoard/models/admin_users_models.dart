import 'dashboard_models.dart';

class AdminUsersQuery {
  const AdminUsersQuery({
    this.currentPage = 1,
    this.pageSize = 10,
    this.search = '',
    this.role,
    this.status,
  });

  final int currentPage;
  final int pageSize;
  final String search;
  final UserDashboardRole? role;
  final UserDashboardStatus? status;

  int get start => (currentPage - 1) * pageSize;
  int get end => start + pageSize - 1;

  AdminUsersQuery copyWith({
    int? currentPage,
    String? search,
    UserDashboardRole? role,
    UserDashboardStatus? status,
    bool clearRole = false,
    bool clearStatus = false,
  }) {
    return AdminUsersQuery(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize,
      search: search ?? this.search,
      role: clearRole ? null : role ?? this.role,
      status: clearStatus ? null : status ?? this.status,
    );
  }
}

class AdminUsersPageData {
  const AdminUsersPageData({required this.users, required this.totalUsers});

  final List<DashboardUser> users;
  final int totalUsers;
}

class UserPagination {
  static int totalPages(int totalUsers, int pageSize) {
    if (totalUsers <= 0) return 1;
    return (totalUsers / pageSize).ceil();
  }

  static int correctedPage(int currentPage, int totalUsers, int pageSize) {
    return currentPage.clamp(1, totalPages(totalUsers, pageSize));
  }

  static ({int first, int last}) visibleRange(
    int currentPage,
    int pageSize,
    int rowCount,
    int totalUsers,
  ) {
    if (totalUsers == 0 || rowCount == 0) return (first: 0, last: 0);
    final first = (currentPage - 1) * pageSize + 1;
    return (first: first, last: first + rowCount - 1);
  }
}

class AdminUsersState {
  const AdminUsersState({
    this.query = const AdminUsersQuery(),
    this.users = const [],
    this.totalUsers = 0,
    this.loading = false,
    this.errorMessage,
    this.processingUserIds = const {},
  });

  final AdminUsersQuery query;
  final List<DashboardUser> users;
  final int totalUsers;
  final bool loading;
  final String? errorMessage;
  final Set<String> processingUserIds;

  int get totalPages => UserPagination.totalPages(totalUsers, query.pageSize);

  AdminUsersState copyWith({
    AdminUsersQuery? query,
    List<DashboardUser>? users,
    int? totalUsers,
    bool? loading,
    String? errorMessage,
    bool clearError = false,
    Set<String>? processingUserIds,
  }) {
    return AdminUsersState(
      query: query ?? this.query,
      users: users ?? this.users,
      totalUsers: totalUsers ?? this.totalUsers,
      loading: loading ?? this.loading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      processingUserIds: processingUserIds ?? this.processingUserIds,
    );
  }
}
