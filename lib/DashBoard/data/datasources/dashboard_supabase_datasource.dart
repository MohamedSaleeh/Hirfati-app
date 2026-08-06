import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DashboardDatasource {
  Future<DashboardRawData> load();
}

class DashboardSupabaseDatasource implements DashboardDatasource {
  DashboardSupabaseDatasource(this._client);

  final SupabaseClient _client;

  @override
  Future<DashboardRawData> load() async {
    final startOfToday = DateTime.now();
    final today = DateTime(
      startOfToday.year,
      startOfToday.month,
      startOfToday.day,
    ).toUtc().toIso8601String();

    final counts = await Future.wait<int>([
      _count('profiles'),
      _count('workers'),
      _count('orders'),
      _count('orders', gte: {'created_at': today}),
      _count(
        'orders',
        inValues: {
          'status': const ['pending', 'accepted', 'in_progress'],
        },
      ),
      _count('orders', equals: {'status': 'completed'}),
      _count(
        'payments',
        equals: {'status': 'completed'},
        nullField: 'parent_payment_id',
      ),
      _count('withdrawals', equals: {'status': 'completed'}),
      _count('verification_requests', equals: {'status': 'pending'}),
      _count('support_messages', equals: {'is_resolved': false}),
      _count('notifications'),
    ]);

    final results = await Future.wait<Object>([
      _rows(
        'profiles',
        'id, full_name, role, avatar_url, city, is_active, created_at',
        orderBy: 'created_at',
        limit: 5,
      ),
      _rows(
        'workers',
        'id, user_id, rating_average, rating_count, is_available, approved',
        orderBy: 'rating_average',
        secondaryOrderBy: 'rating_count',
        limit: 5,
      ),
      _allRows('orders', 'category_id'),
      _rows(
        'categories',
        'id, name, category_translations(locale, name)',
        limit: 500,
      ),
      _rows(
        'orders',
        'id, title, status, created_at',
        orderBy: 'created_at',
        limit: 8,
      ),
      _sumRows(
        'payments',
        'amount',
        equals: {'status': 'completed'},
        nullField: 'parent_payment_id',
      ),
      _sumRows('withdrawals', 'amount', equals: {'status': 'completed'}),
      _sumRows('wallets', 'balance'),
    ]);

    final workers = results[1] as List<Map<String, dynamic>>;
    final userIds = workers
        .map((row) => row['user_id']?.toString())
        .whereType<String>()
        .toList();
    final workerProfiles = userIds.isEmpty
        ? const <Map<String, dynamic>>[]
        : await _rowsByIds('profiles', 'id, full_name, avatar_url', userIds);

    return DashboardRawData(
      counts: {
        'total_users': counts[0],
        'total_workers': counts[1],
        'total_orders': counts[2],
        'orders_today': counts[3],
        'active_orders': counts[4],
        'completed_orders': counts[5],
        'total_completed_payments': counts[6],
        'total_completed_withdrawals': counts[7],
        'pending_verification_requests': counts[8],
        'unresolved_support_messages': counts[9],
        'total_notifications': counts[10],
      },
      latestUsers: results[0] as List<Map<String, dynamic>>,
      workers: workers,
      workerProfiles: workerProfiles,
      categoryOrders: results[2] as List<Map<String, dynamic>>,
      categories: results[3] as List<Map<String, dynamic>>,
      recentOrders: results[4] as List<Map<String, dynamic>>,
      completedPaymentsAmount: results[5] as double,
      completedWithdrawalsAmount: results[6] as double,
      totalWalletBalance: results[7] as double,
    );
  }

  Future<int> _count(
    String table, {
    Map<String, Object> equals = const {},
    Map<String, String> gte = const {},
    Map<String, List<String>> inValues = const {},
    String? nullField,
  }) async {
    dynamic query = _client.from(table).select('id');
    for (final entry in equals.entries) {
      query = query.eq(entry.key, entry.value);
    }
    for (final entry in gte.entries) {
      query = query.gte(entry.key, entry.value);
    }
    for (final entry in inValues.entries) {
      query = query.inFilter(entry.key, entry.value);
    }
    if (nullField != null) query = query.isFilter(nullField, null);
    final result = await query.count();
    return result.count;
  }

  Future<List<Map<String, dynamic>>> _rows(
    String table,
    String columns, {
    String? orderBy,
    String? secondaryOrderBy,
    int limit = 100,
  }) async {
    dynamic query = _client.from(table).select(columns);
    if (orderBy != null) query = query.order(orderBy, ascending: false);
    if (secondaryOrderBy != null) {
      query = query.order(secondaryOrderBy, ascending: false);
    }
    final response = await query.limit(limit) as List<dynamic>;
    return response
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  Future<List<Map<String, dynamic>>> _rowsByIds(
    String table,
    String columns,
    List<String> ids,
  ) async {
    final response =
        await _client.from(table).select(columns).inFilter('id', ids)
            as List<dynamic>;
    return response
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  Future<List<Map<String, dynamic>>> _allRows(
    String table,
    String columns,
  ) async {
    const pageSize = 1000;
    final rows = <Map<String, dynamic>>[];
    var offset = 0;
    while (true) {
      final page =
          await _client
                  .from(table)
                  .select(columns)
                  .range(offset, offset + pageSize - 1)
              as List<dynamic>;
      rows.addAll(
        page.whereType<Map>().map((row) => Map<String, dynamic>.from(row)),
      );
      if (page.length < pageSize) return rows;
      offset += pageSize;
    }
  }

  Future<double> _sumRows(
    String table,
    String field, {
    Map<String, Object> equals = const {},
    String? nullField,
  }) async {
    const pageSize = 1000;
    var offset = 0;
    var total = 0.0;
    while (true) {
      dynamic query = _client.from(table).select(field);
      for (final entry in equals.entries) {
        query = query.eq(entry.key, entry.value);
      }
      if (nullField != null) query = query.isFilter(nullField, null);
      final response =
          await query.range(offset, offset + pageSize - 1) as List<dynamic>;
      total += response.fold<double>(
        0,
        (sum, row) => sum + (((row as Map)[field] as num?)?.toDouble() ?? 0),
      );
      if (response.length < pageSize) return total;
      offset += pageSize;
    }
  }
}

class DashboardRawData {
  const DashboardRawData({
    required this.counts,
    required this.latestUsers,
    required this.workers,
    required this.workerProfiles,
    required this.categoryOrders,
    required this.categories,
    required this.recentOrders,
    required this.completedPaymentsAmount,
    required this.completedWithdrawalsAmount,
    required this.totalWalletBalance,
  });

  final Map<String, dynamic> counts;
  final List<Map<String, dynamic>> latestUsers;
  final List<Map<String, dynamic>> workers;
  final List<Map<String, dynamic>> workerProfiles;
  final List<Map<String, dynamic>> categoryOrders;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> recentOrders;
  final double completedPaymentsAmount;
  final double completedWithdrawalsAmount;
  final double totalWalletBalance;
}
