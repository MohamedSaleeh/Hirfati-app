import '../../domain/repositories/dashboard_repository.dart';
import '../../models/dashboard_models.dart';
import '../datasources/dashboard_supabase_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._datasource);

  final DashboardDatasource _datasource;

  static const activeOrderStatuses = {'pending', 'accepted', 'in_progress'};

  static bool isActiveOrderStatus(String status) {
    return activeOrderStatuses.contains(status);
  }

  @override
  Future<DashboardOverview> loadOverview() async {
    final raw = await _datasource.load();
    final metricsJson = Map<String, dynamic>.from(raw.counts)
      ..addAll({
        'completed_payments_amount': raw.completedPaymentsAmount,
        'completed_withdrawals_amount': raw.completedWithdrawalsAmount,
        'total_wallet_balance': raw.totalWalletBalance,
      });
    return DashboardOverview(
      metrics: DashboardMetrics.fromJson(metricsJson),
      latestUsers: raw.latestUsers.map(_mapUser).toList(),
      topWorkers: _mapWorkers(raw.workers, raw.workerProfiles),
      topCategories: _mapCategories(raw.categoryOrders, raw.categories),
      recentActivity: raw.recentOrders.map(_mapOrderActivity).toList(),
    );
  }

  DashboardUser _mapUser(Map<String, dynamic> row) {
    final role = row['role']?.toString().toLowerCase();
    return DashboardUser(
      id: row['id']?.toString() ?? '',
      name: _text(row['full_name'], 'مستخدم بدون اسم'),
      phone: '',
      role: switch (role) {
        'admin' => UserDashboardRole.admin,
        'worker' => UserDashboardRole.craftsman,
        _ => UserDashboardRole.client,
      },
      status: row['is_active'] == false
          ? UserDashboardStatus.suspended
          : UserDashboardStatus.active,
      lastSeenLabel: '',
      avatarUrl: _nullableText(row['avatar_url']),
      city: _nullableText(row['city']),
      createdAt: DateTime.tryParse(row['created_at']?.toString() ?? ''),
    );
  }

  List<DashboardTopWorker> _mapWorkers(
    List<Map<String, dynamic>> workers,
    List<Map<String, dynamic>> profiles,
  ) {
    final profilesById = {
      for (final profile in profiles) profile['id']?.toString() ?? '': profile,
    };
    return workers.map((worker) {
      final userId = worker['user_id']?.toString() ?? '';
      final profile = profilesById[userId] ?? const <String, dynamic>{};
      return DashboardTopWorker(
        id: worker['id']?.toString() ?? '',
        userId: userId,
        fullName: _text(profile['full_name'], 'حرفي بدون اسم'),
        avatarUrl: _nullableText(profile['avatar_url']),
        ratingAverage: (worker['rating_average'] as num?)?.toDouble() ?? 0,
        ratingCount: (worker['rating_count'] as num?)?.toInt() ?? 0,
        isAvailable: worker['is_available'] == true,
        approved: worker['approved'] == true,
      );
    }).toList();
  }

  List<DashboardTopCategory> _mapCategories(
    List<Map<String, dynamic>> orders,
    List<Map<String, dynamic>> categories,
  ) {
    final counts = <String, int>{};
    for (final order in orders) {
      final categoryId = order['category_id']?.toString();
      if (categoryId != null && categoryId.isNotEmpty) {
        counts.update(categoryId, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    final names = {
      for (final category in categories)
        category['id']?.toString() ?? '': _text(
          _arabicCategoryName(category) ?? category['name'],
          'تصنيف بدون اسم',
        ),
    };
    final result =
        counts.entries
            .map(
              (entry) => DashboardTopCategory(
                id: entry.key,
                name: names[entry.key] ?? 'تصنيف بدون اسم',
                orderCount: entry.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.orderCount.compareTo(a.orderCount));
    return result.take(5).toList();
  }

  Object? _arabicCategoryName(Map<String, dynamic> category) {
    final translations = category['category_translations'];
    if (translations is! List) return null;
    for (final translation in translations.whereType<Map>()) {
      if (translation['locale']?.toString() == 'ar') {
        return translation['name'];
      }
    }
    return null;
  }

  DashboardActivityItem _mapOrderActivity(Map<String, dynamic> order) {
    final status = order['status']?.toString() ?? '';
    return DashboardActivityItem(
      title: 'طلب خدمة',
      description: _text(order['title'], status),
      createdAt:
          DateTime.tryParse(order['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      tone: status == 'completed' ? ActivityTone.success : ActivityTone.neutral,
    );
  }

  String _text(Object? value, String fallback) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  String? _nullableText(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}
