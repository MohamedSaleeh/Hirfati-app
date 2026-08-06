import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/DashBoard/data/datasources/dashboard_supabase_datasource.dart';
import 'package:hirfati/DashBoard/data/repositories/dashboard_repository_impl.dart';
import 'package:hirfati/DashBoard/domain/repositories/dashboard_repository.dart';
import 'package:hirfati/DashBoard/models/dashboard_models.dart';
import 'package:hirfati/DashBoard/providers/dashboard_providers.dart';

void main() {
  test('numeric model parses values and converts null sums to zero', () {
    final metrics = DashboardMetrics.fromJson({
      'total_users': 12,
      'total_workers': 4,
      'completed_payments_amount': null,
      'completed_withdrawals_amount': 25,
      'total_wallet_balance': null,
    });

    expect(metrics.totalUsers, 12);
    expect(metrics.totalWorkers, 4);
    expect(metrics.completedPaymentsAmount, 0);
    expect(metrics.completedWithdrawalsAmount, 25);
    expect(metrics.totalWalletBalance, 0);
  });

  test('active order definition includes only beta active statuses', () {
    expect(DashboardRepositoryImpl.isActiveOrderStatus('pending'), isTrue);
    expect(DashboardRepositoryImpl.isActiveOrderStatus('accepted'), isTrue);
    expect(DashboardRepositoryImpl.isActiveOrderStatus('in_progress'), isTrue);
    expect(DashboardRepositoryImpl.isActiveOrderStatus('completed'), isFalse);
    expect(DashboardRepositoryImpl.isActiveOrderStatus('cancelled'), isFalse);
    expect(DashboardRepositoryImpl.isActiveOrderStatus('rejected'), isFalse);
  });

  test('repository aggregates categories and maps real rows', () async {
    final repository = DashboardRepositoryImpl(_DataSource(_rawData));
    final overview = await repository.loadOverview();

    expect(overview.metrics.totalOrders, 3);
    expect(overview.metrics.completedPaymentsAmount, 100);
    expect(overview.latestUsers.single.name, 'Latest User');
    expect(overview.topWorkers.single.fullName, 'Top Worker');
    expect(overview.topCategories.single.name, 'Plumbing');
    expect(overview.topCategories.single.orderCount, 2);
    expect(overview.recentActivity, hasLength(1));
  });

  test('repository preserves empty dashboard lists', () async {
    final repository = DashboardRepositoryImpl(
      _DataSource(
        const DashboardRawData(
          counts: {},
          latestUsers: [],
          workers: [],
          workerProfiles: [],
          categoryOrders: [],
          categories: [],
          recentOrders: [],
          completedPaymentsAmount: 0,
          completedWithdrawalsAmount: 0,
          totalWalletBalance: 0,
        ),
      ),
    );
    final overview = await repository.loadOverview();

    expect(overview.latestUsers, isEmpty);
    expect(overview.topWorkers, isEmpty);
    expect(overview.topCategories, isEmpty);
    expect(overview.recentActivity, isEmpty);
  });

  test('overview provider exposes loading then successful state', () async {
    final completer = Completer<DashboardOverview>();
    final container = ProviderContainer(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(
          _Repository(() => completer.future),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(dashboardOverviewProvider).isLoading, isTrue);
    completer.complete(_overview);
    expect(await container.read(dashboardOverviewProvider.future), _overview);
    expect(container.read(dashboardOverviewProvider).hasValue, isTrue);
  });

  test('overview provider exposes datasource/repository errors', () async {
    final container = ProviderContainer(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(
          _Repository(() => Future.error(StateError('query failed'))),
        ),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(dashboardOverviewProvider.future),
      throwsStateError,
    );
    expect(container.read(dashboardOverviewProvider).hasError, isTrue);
  });
}

class _DataSource implements DashboardDatasource {
  const _DataSource(this.data);
  final DashboardRawData data;

  @override
  Future<DashboardRawData> load() async => data;
}

class _Repository implements DashboardRepository {
  const _Repository(this.loader);
  final Future<DashboardOverview> Function() loader;

  @override
  Future<DashboardOverview> loadOverview() => loader();
}

const _overview = DashboardOverview(
  metrics: DashboardMetrics.zero,
  latestUsers: [],
  topWorkers: [],
  topCategories: [],
  recentActivity: [],
);

final _rawData = DashboardRawData(
  counts: const {'total_orders': 3},
  latestUsers: const [
    {
      'id': 'user-1',
      'full_name': 'Latest User',
      'role': 'client',
      'is_active': true,
      'created_at': '2026-08-06T10:00:00Z',
    },
  ],
  workers: const [
    {
      'id': 'worker-1',
      'user_id': 'worker-user-1',
      'rating_average': 4.9,
      'rating_count': 20,
      'is_available': true,
      'approved': true,
    },
  ],
  workerProfiles: const [
    {'id': 'worker-user-1', 'full_name': 'Top Worker', 'avatar_url': null},
  ],
  categoryOrders: const [
    {'category_id': 'category-1'},
    {'category_id': 'category-1'},
  ],
  categories: const [
    {'id': 'category-1', 'name': 'Plumbing'},
  ],
  recentOrders: const [
    {
      'id': 'order-1',
      'title': 'Recent order',
      'status': 'pending',
      'created_at': '2026-08-06T10:00:00Z',
    },
  ],
  completedPaymentsAmount: 100,
  completedWithdrawalsAmount: 25,
  totalWalletBalance: 75,
);
