import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/DashBoard/data/datasources/admin_users_datasource.dart';
import 'package:hirfati/DashBoard/domain/repositories/admin_users_repository.dart';
import 'package:hirfati/DashBoard/models/admin_users_models.dart';
import 'package:hirfati/DashBoard/models/dashboard_models.dart';
import 'package:hirfati/DashBoard/providers/dashboard_providers.dart';

void main() {
  group('Admin users pagination', () {
    test('uses inclusive Supabase ranges for each page', () {
      expect(
        AdminUsersDatasource.rangeFor(const AdminUsersQuery(currentPage: 1)),
        (start: 0, end: 9),
      );
      expect(
        AdminUsersDatasource.rangeFor(const AdminUsersQuery(currentPage: 2)),
        (start: 10, end: 19),
      );
      expect(
        AdminUsersDatasource.rangeFor(const AdminUsersQuery(currentPage: 3)),
        (start: 20, end: 29),
      );
    });

    test('calculates pages, footer ranges, and empty state', () {
      expect(UserPagination.totalPages(26, 10), 3);
      expect(UserPagination.visibleRange(1, 10, 10, 26), (first: 1, last: 10));
      expect(UserPagination.visibleRange(2, 10, 10, 26), (first: 11, last: 20));
      expect(UserPagination.visibleRange(3, 10, 6, 26), (first: 21, last: 26));
      expect(UserPagination.visibleRange(1, 10, 0, 0), (first: 0, last: 0));
      expect(UserPagination.correctedPage(4, 26, 10), 3);
      expect(UserPagination.correctedPage(0, 26, 10), 1);
    });

    test('search resets the current page and requests page one', () async {
      final repository = _FakeRepository(totalUsers: 26);
      final controller = AdminUsersController(
        repository,
        'admin',
        initialState: const AdminUsersState(
          query: AdminUsersQuery(currentPage: 3),
          totalUsers: 26,
        ),
        autoLoad: false,
      );

      await controller.setSearch('Riyadh');

      expect(repository.queries.single.currentPage, 1);
      expect(repository.queries.single.search, 'Riyadh');
    });

    test('page navigation clamps to valid boundaries', () async {
      final repository = _FakeRepository(totalUsers: 26);
      final controller = AdminUsersController(
        repository,
        'admin',
        initialState: const AdminUsersState(totalUsers: 26),
        autoLoad: false,
      );

      await controller.goToPage(0);
      expect(repository.queries, isEmpty);
      await controller.goToPage(99);
      expect(repository.queries.single.currentPage, 3);
    });

    test('corrects an invalid page after the result count shrinks', () async {
      final repository = _FakeRepository(totalUsers: 6);
      final controller = AdminUsersController(
        repository,
        'admin',
        initialState: const AdminUsersState(
          query: AdminUsersQuery(currentPage: 3),
          totalUsers: 26,
        ),
        autoLoad: false,
      );

      await controller.load();

      expect(repository.queries.map((query) => query.currentPage), [3, 1]);
      expect(controller.state.query.currentPage, 1);
    });
  });

  group('Admin user status', () {
    test('builds the expected RPC parameters', () {
      expect(
        AdminUsersDatasource.statusParameters(
          userId: 'user-1',
          isActive: false,
        ),
        {'p_user_id': 'user-1', 'p_is_active': false},
      );
    });

    test('rejects disabling the signed-in admin', () async {
      final repository = _FakeRepository();
      final controller = AdminUsersController(
        repository,
        'admin',
        autoLoad: false,
      );

      await expectLater(
        controller.setActiveStatus('admin', false),
        throwsA(isA<AdminUsersActionException>()),
      );
      expect(repository.statusCalls, isEmpty);
    });

    test(
      'prevents duplicate row actions and refreshes after success',
      () async {
        final gate = Completer<void>();
        final repository = _FakeRepository(statusGate: gate);
        final controller = AdminUsersController(
          repository,
          'admin',
          autoLoad: false,
        );

        final first = controller.setActiveStatus('user-1', false);
        final duplicate = await controller.setActiveStatus('user-1', false);
        expect(duplicate, isFalse);
        expect(repository.statusCalls, [('user-1', false)]);

        gate.complete();
        expect(await first, isTrue);
        expect(repository.queries.length, 1);
        expect(controller.state.processingUserIds, isEmpty);
      },
    );
  });
}

class _FakeRepository implements AdminUsersRepository {
  _FakeRepository({this.totalUsers = 0, this.statusGate});

  int totalUsers;
  final Completer<void>? statusGate;
  final List<AdminUsersQuery> queries = [];
  final List<(String, bool)> statusCalls = [];

  @override
  Future<AdminUsersPageData> loadUsers(AdminUsersQuery query) async {
    queries.add(query);
    final remaining = totalUsers - query.start;
    final count = remaining.clamp(0, query.pageSize);
    return AdminUsersPageData(
      users: List.generate(count, (index) => _user('${query.start + index}')),
      totalUsers: totalUsers,
    );
  }

  @override
  Future<void> setActiveStatus({
    required String userId,
    required bool isActive,
  }) async {
    statusCalls.add((userId, isActive));
    await statusGate?.future;
  }

  DashboardUser _user(String id) => DashboardUser(
    id: id,
    name: 'User $id',
    phone: '0500000000',
    role: UserDashboardRole.client,
    status: UserDashboardStatus.active,
    lastSeenLabel: '-',
  );
}
