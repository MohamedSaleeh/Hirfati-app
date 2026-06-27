import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dashboard_models.dart';

class DashboardAdminService {
  DashboardAdminService(this._client);

  final SupabaseClient _client;

  String? get currentUserId => _client.auth.currentUser?.id;

  String? get currentUserEmail => _client.auth.currentUser?.email;

  Future<bool> isCurrentUserAdmin() async {
    final userId = currentUserId;
    if (userId == null) return false;

    final profile = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();

    return profile?['role']?.toString().toLowerCase() == 'admin';
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<DashboardSnapshot> loadDashboard() async {
    final profiles = await _selectRows(
      'profiles',
      orderBy: 'created_at',
      limit: 500,
    );
    final workers = await _selectRows(
      'workers',
      orderBy: 'updated_at',
      limit: 500,
    );
    final categories = await _selectRows(
      'categories',
      orderBy: 'created_at',
      limit: 200,
    );
    final supportMessages = await _selectRows(
      'support_messages',
      orderBy: 'created_at',
      limit: 250,
    );
    final orders = await _selectRows(
      'orders',
      orderBy: 'created_at',
      limit: 120,
      requiredSource: false,
    );
    final notifications = await _selectRows(
      'notifications',
      orderBy: 'created_at',
      limit: 120,
      requiredSource: false,
    );

    final totalUsersCount = await _countRows('profiles');
    final activeUsersCount = await _countRows(
      'profiles',
      equals: {'is_active': true},
    );
    final workersCount = await _countRows(
      'profiles',
      equals: {'role': 'worker'},
    );
    final clientsCount = await _countRows(
      'profiles',
      equals: {'role': 'client'},
    );
    final adminsCount = await _countRows(
      'profiles',
      equals: {'role': 'admin'},
    );
    final pendingVerificationCount = await _countRows(
      'workers',
      equals: {
        'approved': false,
        'profile_completed': true,
      },
    );
    final openComplaintsCount = await _countRows(
      'support_messages',
      equals: {'is_resolved': false},
    );
    final disabledAccountsCount = await _countRows(
      'profiles',
      equals: {'is_active': false},
    );

    final categoryNamesById = <String, String>{
      for (final category in categories)
        if (category['id'] != null)
          category['id'].toString():
              _readString(category, ['name'], 'غير مصنف'),
    };

    final profilesById = <String, Map<String, dynamic>>{
      for (final profile in profiles)
        if (profile['id'] != null) profile['id'].toString(): profile,
    };

    final workersByUserId = <String, Map<String, dynamic>>{
      for (final worker in workers)
        if (worker['user_id'] != null) worker['user_id'].toString(): worker,
    };

    final users = _mapUsers(profiles, workersByUserId, categoryNamesById);
    final verifications = _mapVerificationRequests(
      workers,
      profilesById,
      categoryNamesById,
    );
    final complaints = _mapComplaints(supportMessages, users);
    final deletionRecords = _mapDisabledProfiles(profiles);

    return DashboardSnapshot(
      users: users,
      verificationRequests: verifications,
      complaints: complaints,
      deletionRecords: deletionRecords,
      activityItems: _buildActivity(
        profiles: profiles,
        workers: workers,
        supportMessages: supportMessages,
        orders: orders,
        notifications: notifications,
        profilesById: profilesById,
        categoryNamesById: categoryNamesById,
      ),
      totalUsersCount: totalUsersCount,
      activeUsersCount: activeUsersCount,
      workersCount: workersCount,
      clientsCount: clientsCount,
      adminsCount: adminsCount,
      pendingVerificationRequestsCount: pendingVerificationCount,
      openComplaintsRowsCount: openComplaintsCount,
      disabledAccountsCount: disabledAccountsCount,
      usesPlaceholderDeletionLog: false,
    );
  }

  Future<void> setUserActive({
    required String userId,
    required bool isActive,
  }) async {
    await _client.from('profiles').update({
      'is_active': isActive,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  Future<void> updateVerificationStatus({
    required DashboardVerificationRequest request,
    required VerificationDashboardStatus status,
  }) async {
    await _client.from('workers').update({
      'approved': status == VerificationDashboardStatus.approved,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', request.id);
  }

  Future<void> setComplaintResolved({
    required String complaintId,
    required bool isResolved,
  }) async {
    await _client
        .from('support_messages')
        .update({'is_resolved': isResolved}).eq('id', complaintId);
  }

  Future<DashboardNotificationSettings> loadMyNotificationSettings() async {
    final userId = currentUserId;
    if (userId == null) return DashboardNotificationSettings.defaults;

    final row = await _client
        .from('notification_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) return DashboardNotificationSettings.defaults;
    return _mapNotificationSettings(row);
  }

  Future<void> saveMyNotificationSettings(
    DashboardNotificationSettings settings,
  ) async {
    final userId = currentUserId;
    if (userId == null) {
      throw StateError('لا توجد جلسة مستخدم نشطة.');
    }

    final values = {
      'user_id': userId,
      'push_enabled': settings.pushEnabled,
      'email_enabled': settings.emailEnabled,
      'sms_enabled': settings.smsEnabled,
      'order_confirmation': settings.orderConfirmation,
      'order_status': settings.orderStatus,
      'promotions': settings.promotions,
    };

    final existing = await _client
        .from('notification_settings')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (existing == null) {
      await _client.from('notification_settings').insert(values);
      return;
    }

    await _client
        .from('notification_settings')
        .update(values)
        .eq('id', existing['id']);
  }

  Future<List<Map<String, dynamic>>> _selectRows(
    String table, {
    String columns = '*',
    String? orderBy,
    bool ascending = false,
    int limit = 100,
    bool requiredSource = true,
  }) async {
    try {
      dynamic query = _client.from(table).select(columns);
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      query = query.limit(limit);
      final response = await query as List<dynamic>;
      return response
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    } catch (error) {
      if (requiredSource) {
        throw Exception('تعذر تحميل بيانات $table: $error');
      }
      return const [];
    }
  }

  Future<int> _countRows(
    String table, {
    Map<String, Object> equals = const {},
  }) async {
    dynamic query = _client.from(table).select();
    for (final entry in equals.entries) {
      query = query.eq(entry.key, entry.value);
    }
    final count = await query.count();
    return count.count;
  }

  List<DashboardUser> _mapUsers(
    List<Map<String, dynamic>> profiles,
    Map<String, Map<String, dynamic>> workersByUserId,
    Map<String, String> categoryNamesById,
  ) {
    return profiles.map((profile) {
      final id = _readString(profile, ['id'], '');
      final worker = workersByUserId[id];
      final roleValue =
          _readString(profile, ['role'], worker == null ? 'client' : 'worker');
      final categoryId = worker?['category_id']?.toString();
      final createdAt = _parseDate(profile['created_at']);
      final updatedAt = _parseDate(profile['updated_at']);

      return DashboardUser(
        id: id,
        name: _readString(profile, ['full_name'], 'مستخدم بدون اسم'),
        phone: _readString(profile, ['phone'], 'غير متوفر'),
        role: _parseUserRole(roleValue, worker != null),
        status: _parseUserStatus(profile),
        lastSeenLabel: _relativeLabel(updatedAt ?? createdAt),
        avatarUrl: _readNullableString(profile, 'avatar_url'),
        specialty: categoryId == null ? null : categoryNamesById[categoryId],
        city: _readNullableString(profile, 'city'),
        workerId: worker?['id']?.toString(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }).toList();
  }

  List<DashboardVerificationRequest> _mapVerificationRequests(
    List<Map<String, dynamic>> workers,
    Map<String, Map<String, dynamic>> profilesById,
    Map<String, String> categoryNamesById,
  ) {
    final rows = workers.where((worker) {
      return worker['approved'] == false && worker['profile_completed'] == true;
    }).toList();

    return rows.map((worker) {
      final userId = _readString(worker, ['user_id'], '');
      final profile = profilesById[userId] ?? const <String, dynamic>{};
      final categoryId = worker['category_id']?.toString();

      return DashboardVerificationRequest(
        id: _readString(worker, ['id'], ''),
        userId: userId,
        craftsmanName: _readString(profile, ['full_name'], 'حرفي بدون اسم'),
        phone: _readString(profile, ['phone'], 'غير متوفر'),
        city: _readString(profile, ['city'], 'غير متوفر'),
        specialty: categoryId == null
            ? 'غير محدد'
            : categoryNamesById[categoryId] ?? 'غير محدد',
        experienceYears: _readInt(worker['experience_years']),
        ratingAverage: _readDouble(worker['rating_average']),
        status: VerificationDashboardStatus.pending,
        requestedAt: _parseDate(worker['updated_at']) ??
            _parseDate(worker['created_at']),
        attachments: const {},
      );
    }).toList();
  }

  List<DashboardComplaint> _mapComplaints(
    List<Map<String, dynamic>> rows,
    List<DashboardUser> users,
  ) {
    final usersById = {for (final user in users) user.id: user};

    return rows.map((row) {
      final userId = _readString(row, ['user_id'], '');
      final user = usersById[userId];
      final subject = _readString(row, ['subject'], 'رسالة دعم');
      final message = _readString(row, ['message'], '');
      final isResolved = row['is_resolved'] == true;
      final createdAt = _parseDate(row['created_at']);

      return DashboardComplaint(
        id: _readString(row, ['id'], ''),
        complainantName: user?.name ?? 'مستخدم غير معروف',
        complainantRole: _roleLabel(user?.role ?? UserDashboardRole.client),
        subject: subject,
        message: message,
        status: isResolved
            ? ComplaintDashboardStatus.archived
            : ComplaintDashboardStatus.open,
        priority: _complaintPriority(subject, message, createdAt),
        createdAt: createdAt,
      );
    }).toList();
  }

  List<DeletedAccountRecord> _mapDisabledProfiles(
    List<Map<String, dynamic>> profiles,
  ) {
    return profiles
        .where((profile) => profile['is_active'] == false)
        .map((row) {
      final role = _parseUserRole(_readString(row, ['role'], 'client'), false);
      return DeletedAccountRecord(
        id: _readString(row, ['id'], ''),
        accountName: _readString(row, ['full_name'], 'حساب غير نشط'),
        role: _roleLabel(role),
        phone: _readString(row, ['phone'], 'غير متوفر'),
        city: _readString(row, ['city'], 'غير متوفر'),
        reason: 'غير متوفر',
        deletedAt: _parseDate(row['updated_at']) ??
            _parseDate(row['created_at']) ??
            DateTime.now(),
        deletedBy: 'غير متوفر',
        isSuspicious: false,
      );
    }).toList();
  }

  List<DashboardActivityItem> _buildActivity({
    required List<Map<String, dynamic>> profiles,
    required List<Map<String, dynamic>> workers,
    required List<Map<String, dynamic>> supportMessages,
    required List<Map<String, dynamic>> orders,
    required List<Map<String, dynamic>> notifications,
    required Map<String, Map<String, dynamic>> profilesById,
    required Map<String, String> categoryNamesById,
  }) {
    final items = <DashboardActivityItem>[];

    for (final message in supportMessages.take(5)) {
      final createdAt = _parseDate(message['created_at']);
      if (createdAt == null) continue;
      final profile = profilesById[_readString(message, ['user_id'], '')];
      final subject = _readString(message, ['subject'], 'رسالة دعم');
      final userName = _readString(
        profile ?? const <String, dynamic>{},
        ['full_name'],
        'مستخدم غير معروف',
      );
      items.add(
        DashboardActivityItem(
          title: message['is_resolved'] == true ? 'تم حل شكوى' : 'شكوى جديدة',
          description: '$subject - $userName',
          createdAt: createdAt,
          tone: message['is_resolved'] == true
              ? ActivityTone.success
              : ActivityTone.warning,
        ),
      );
    }

    for (final worker in workers
        .where((row) =>
            row['approved'] == false && row['profile_completed'] == true)
        .take(5)) {
      final createdAt =
          _parseDate(worker['updated_at']) ?? _parseDate(worker['created_at']);
      if (createdAt == null) continue;
      final profile = profilesById[_readString(worker, ['user_id'], '')];
      final categoryId = worker['category_id']?.toString();
      final workerName = _readString(
        profile ?? const <String, dynamic>{},
        ['full_name'],
        'حرفي بدون اسم',
      );
      final categoryName = categoryNamesById[categoryId] ?? 'غير محدد';
      items.add(
        DashboardActivityItem(
          title: 'طلب توثيق حرفي',
          description: '$workerName - $categoryName',
          createdAt: createdAt,
          tone: ActivityTone.neutral,
        ),
      );
    }

    for (final profile in profiles.take(5)) {
      final updatedAt = _parseDate(profile['updated_at']);
      if (updatedAt == null) continue;
      items.add(
        DashboardActivityItem(
          title: profile['is_active'] == false
              ? 'تعطيل حساب'
              : 'تحديث حساب مستخدم',
          description: _readString(profile, ['full_name'], 'مستخدم بدون اسم'),
          createdAt: updatedAt,
          tone: profile['is_active'] == false
              ? ActivityTone.danger
              : ActivityTone.neutral,
        ),
      );
    }

    for (final order in orders.take(4)) {
      final createdAt = _parseDate(order['created_at']);
      if (createdAt == null) continue;
      items.add(
        DashboardActivityItem(
          title: 'طلب خدمة',
          description: _readString(order, ['title', 'status'], 'طلب جديد'),
          createdAt: createdAt,
          tone: ActivityTone.success,
        ),
      );
    }

    for (final notification in notifications.take(4)) {
      final createdAt = _parseDate(notification['created_at']);
      if (createdAt == null) continue;
      items.add(
        DashboardActivityItem(
          title: _readString(notification, ['title'], 'إشعار'),
          description: _readString(notification, ['body', 'type'], ''),
          createdAt: createdAt,
          tone: ActivityTone.neutral,
        ),
      );
    }

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items.take(8).toList();
  }

  DashboardNotificationSettings _mapNotificationSettings(
    Map<String, dynamic> row,
  ) {
    return DashboardNotificationSettings(
      pushEnabled: row['push_enabled'] as bool? ?? true,
      emailEnabled: row['email_enabled'] as bool? ?? true,
      smsEnabled: row['sms_enabled'] as bool? ?? false,
      orderConfirmation: row['order_confirmation'] as bool? ?? true,
      orderStatus: row['order_status'] as bool? ?? true,
      promotions: row['promotions'] as bool? ?? true,
    );
  }

  UserDashboardRole _parseUserRole(String role, bool isWorker) {
    final normalized = role.toLowerCase();
    if (normalized == 'admin') return UserDashboardRole.admin;
    if (normalized == 'worker' || isWorker) return UserDashboardRole.craftsman;
    return UserDashboardRole.client;
  }

  UserDashboardStatus _parseUserStatus(Map<String, dynamic> profile) {
    return profile['is_active'] == false
        ? UserDashboardStatus.suspended
        : UserDashboardStatus.active;
  }

  ComplaintPriority _complaintPriority(
    String subject,
    String message,
    DateTime? createdAt,
  ) {
    final text = '$subject $message'.toLowerCase();
    if (text.contains('عاجل') ||
        text.contains('احتيال') ||
        text.contains('خطر') ||
        text.contains('urgent') ||
        text.contains('fraud')) {
      return ComplaintPriority.high;
    }
    if (createdAt != null && DateTime.now().difference(createdAt).inDays >= 2) {
      return ComplaintPriority.medium;
    }
    return ComplaintPriority.low;
  }

  String _readString(
    Map<String, dynamic> row,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final value = row[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  String? _readNullableString(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value == null || value.toString().trim().isEmpty) return null;
    return value.toString();
  }

  int? _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  double? _readDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  String _relativeLabel(DateTime? date) {
    if (date == null) return 'غير معروف';
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 1) return 'الآن';
    if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
    if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
    if (difference.inDays < 7) return 'منذ ${difference.inDays} أيام';
    return 'منذ أسبوع';
  }

  String _roleLabel(UserDashboardRole role) {
    return switch (role) {
      UserDashboardRole.client => 'عميل',
      UserDashboardRole.craftsman => 'حرفي',
      UserDashboardRole.admin => 'مدير',
    };
  }
}
