enum DashboardSection {
  overview,
  users,
  verification,
  complaints,
  deletions,
  settings,
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.users,
    required this.verificationRequests,
    required this.complaints,
    required this.deletionRecords,
    required this.activityItems,
    required this.totalUsersCount,
    required this.activeUsersCount,
    required this.workersCount,
    required this.clientsCount,
    required this.adminsCount,
    required this.pendingVerificationRequestsCount,
    required this.openComplaintsRowsCount,
    required this.disabledAccountsCount,
    required this.usesPlaceholderDeletionLog,
    this.metrics = DashboardMetrics.zero,
    this.latestUsers = const [],
    this.topWorkers = const [],
    this.topCategories = const [],
  });

  final List<DashboardUser> users;
  final List<DashboardVerificationRequest> verificationRequests;
  final List<DashboardComplaint> complaints;
  final List<DeletedAccountRecord> deletionRecords;
  final List<DashboardActivityItem> activityItems;
  final int totalUsersCount;
  final int activeUsersCount;
  final int workersCount;
  final int clientsCount;
  final int adminsCount;
  final int pendingVerificationRequestsCount;
  final int openComplaintsRowsCount;
  final int disabledAccountsCount;
  final bool usesPlaceholderDeletionLog;
  final DashboardMetrics metrics;
  final List<DashboardUser> latestUsers;
  final List<DashboardTopWorker> topWorkers;
  final List<DashboardTopCategory> topCategories;

  static const empty = DashboardSnapshot(
    users: [],
    verificationRequests: [],
    complaints: [],
    deletionRecords: [],
    activityItems: [],
    totalUsersCount: 0,
    activeUsersCount: 0,
    workersCount: 0,
    clientsCount: 0,
    adminsCount: 0,
    pendingVerificationRequestsCount: 0,
    openComplaintsRowsCount: 0,
    disabledAccountsCount: 0,
    usesPlaceholderDeletionLog: false,
  );

  int get totalUsers => totalUsersCount;

  int get pendingVerificationCount => pendingVerificationRequestsCount;

  int get openComplaintsCount => openComplaintsRowsCount;

  int get deletedAccountsCount => disabledAccountsCount;

  DashboardSnapshot withOverview(DashboardOverview overview) {
    return DashboardSnapshot(
      users: users,
      verificationRequests: verificationRequests,
      complaints: complaints,
      deletionRecords: deletionRecords,
      activityItems: overview.recentActivity,
      totalUsersCount: overview.metrics.totalUsers,
      activeUsersCount: activeUsersCount,
      workersCount: overview.metrics.totalWorkers,
      clientsCount: clientsCount,
      adminsCount: adminsCount,
      pendingVerificationRequestsCount:
          overview.metrics.pendingVerificationRequests,
      openComplaintsRowsCount: overview.metrics.unresolvedSupportMessages,
      disabledAccountsCount: disabledAccountsCount,
      usesPlaceholderDeletionLog: false,
      metrics: overview.metrics,
      latestUsers: overview.latestUsers,
      topWorkers: overview.topWorkers,
      topCategories: overview.topCategories,
    );
  }

  List<DashboardComplaint> get urgentComplaints => complaints
      .where(
        (complaint) =>
            complaint.priority == ComplaintPriority.high &&
            complaint.status != ComplaintDashboardStatus.archived,
      )
      .take(3)
      .toList();
}

class DashboardMetrics {
  const DashboardMetrics({
    required this.totalUsers,
    required this.totalWorkers,
    required this.totalOrders,
    required this.ordersToday,
    required this.activeOrders,
    required this.completedOrders,
    required this.completedPaymentsAmount,
    required this.completedWithdrawalsAmount,
    required this.totalWalletBalance,
    required this.pendingVerificationRequests,
    required this.unresolvedSupportMessages,
    required this.totalNotifications,
  });

  final int totalUsers;
  final int totalWorkers;
  final int totalOrders;
  final int ordersToday;
  final int activeOrders;
  final int completedOrders;
  final double completedPaymentsAmount;
  final double completedWithdrawalsAmount;
  final double totalWalletBalance;
  final int pendingVerificationRequests;
  final int unresolvedSupportMessages;
  final int totalNotifications;

  static const zero = DashboardMetrics(
    totalUsers: 0,
    totalWorkers: 0,
    totalOrders: 0,
    ordersToday: 0,
    activeOrders: 0,
    completedOrders: 0,
    completedPaymentsAmount: 0,
    completedWithdrawalsAmount: 0,
    totalWalletBalance: 0,
    pendingVerificationRequests: 0,
    unresolvedSupportMessages: 0,
    totalNotifications: 0,
  );

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    int integer(String key) => (json[key] as num?)?.toInt() ?? 0;
    double decimal(String key) => (json[key] as num?)?.toDouble() ?? 0;
    return DashboardMetrics(
      totalUsers: integer('total_users'),
      totalWorkers: integer('total_workers'),
      totalOrders: integer('total_orders'),
      ordersToday: integer('orders_today'),
      activeOrders: integer('active_orders'),
      completedOrders: integer('completed_orders'),
      completedPaymentsAmount: decimal('completed_payments_amount'),
      completedWithdrawalsAmount: decimal('completed_withdrawals_amount'),
      totalWalletBalance: decimal('total_wallet_balance'),
      pendingVerificationRequests: integer('pending_verification_requests'),
      unresolvedSupportMessages: integer('unresolved_support_messages'),
      totalNotifications: integer('total_notifications'),
    );
  }
}

class DashboardTopWorker {
  const DashboardTopWorker({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.ratingAverage,
    required this.ratingCount,
    required this.isAvailable,
    required this.approved,
    this.avatarUrl,
  });

  final String id;
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final double ratingAverage;
  final int ratingCount;
  final bool isAvailable;
  final bool approved;
}

class DashboardTopCategory {
  const DashboardTopCategory({
    required this.id,
    required this.name,
    required this.orderCount,
  });

  final String id;
  final String name;
  final int orderCount;
}

class DashboardOverview {
  const DashboardOverview({
    required this.metrics,
    required this.latestUsers,
    required this.topWorkers,
    required this.topCategories,
    required this.recentActivity,
  });

  final DashboardMetrics metrics;
  final List<DashboardUser> latestUsers;
  final List<DashboardTopWorker> topWorkers;
  final List<DashboardTopCategory> topCategories;
  final List<DashboardActivityItem> recentActivity;
}

class DashboardUser {
  const DashboardUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.status,
    required this.lastSeenLabel,
    this.avatarUrl,
    this.specialty,
    this.city,
    this.workerId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String phone;
  final UserDashboardRole role;
  final UserDashboardStatus status;
  final String lastSeenLabel;
  final String? avatarUrl;
  final String? specialty;
  final String? city;
  final String? workerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get initials {
    final parts = name.trim().split(' ').where((part) => part.isNotEmpty);
    if (parts.isEmpty || parts.first.isEmpty) return 'ح';
    return parts.take(2).map((part) => part.substring(0, 1)).join();
  }
}

enum UserDashboardRole { client, craftsman, admin }

enum UserDashboardStatus { active, pendingReview, suspended }

class DashboardVerificationRequest {
  const DashboardVerificationRequest({
    required this.id,
    required this.userId,
    required this.craftsmanName,
    required this.phone,
    required this.city,
    required this.specialty,
    required this.experienceYears,
    required this.ratingAverage,
    required this.status,
    required this.requestedAt,
    required this.attachments,
    this.rejectionReason,
    this.age,
    this.email,
    this.nationalIdFrontUrl,
    this.nationalIdBackUrl,
    this.passportUrl,
    this.driversLicenseUrl,
    this.selfieUrl,
    this.avatarUrl,
    this.profileRole,
    this.profileIsActive,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String craftsmanName;
  final String phone;
  final String city;
  final String specialty;
  final int? experienceYears;
  final double? ratingAverage;
  final VerificationDashboardStatus status;
  final DateTime? requestedAt;
  final Map<String, String> attachments;
  final String? rejectionReason;
  final int? age;
  final String? email;
  final String? nationalIdFrontUrl;
  final String? nationalIdBackUrl;
  final String? passportUrl;
  final String? driversLicenseUrl;
  final String? selfieUrl;
  final String? avatarUrl;
  final String? profileRole;
  final bool? profileIsActive;
  final DateTime? updatedAt;

  factory DashboardVerificationRequest.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? profile,
  }) {
    final nationalId = VerificationDocumentUrls.parseNationalId(
      json['national_id_url'],
    );
    String? text(Object? value) {
      final result = value?.toString().trim();
      return result == null || result.isEmpty ? null : result;
    }

    int? age(Object? value) {
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '');
    }

    VerificationDashboardStatus status(Object? value) =>
        switch (value?.toString()) {
          'approved' => VerificationDashboardStatus.approved,
          'rejected' => VerificationDashboardStatus.rejected,
          _ => VerificationDashboardStatus.pending,
        };

    final requestName = text(json['full_name']);
    final profileName = text(profile?['full_name']);
    return DashboardVerificationRequest(
      id: text(json['id']) ?? '',
      userId: text(json['user_id']) ?? '',
      craftsmanName: profileName ?? requestName ?? 'حرفي بدون اسم',
      phone: text(profile?['phone']) ?? 'غير متوفر',
      city: text(profile?['city']) ?? 'غير متوفر',
      specialty: 'غير محدد',
      experienceYears: null,
      ratingAverage: null,
      status: status(json['status']),
      requestedAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      attachments: {
        if (nationalId.frontUrl != null) 'national_id_front': nationalId.frontUrl!,
        if (nationalId.backUrl != null) 'national_id_back': nationalId.backUrl!,
        if (text(json['passport_url']) != null)
          'passport': text(json['passport_url'])!,
        if (text(json['drivers_license_url']) != null)
          'drivers_license': text(json['drivers_license_url'])!,
        if (text(json['selfie_url']) != null) 'selfie': text(json['selfie_url'])!,
      },
      rejectionReason: text(json['rejection_reason']),
      age: age(json['age']),
      email: text(json['email']),
      nationalIdFrontUrl: nationalId.frontUrl,
      nationalIdBackUrl: nationalId.backUrl,
      passportUrl: text(json['passport_url']),
      driversLicenseUrl: text(json['drivers_license_url']),
      selfieUrl: text(json['selfie_url']),
      avatarUrl: text(profile?['avatar_url']),
      profileRole: text(profile?['role']),
      profileIsActive: profile?['is_active'] as bool?,
    );
  }
}

class VerificationDocumentUrls {
  const VerificationDocumentUrls({this.frontUrl, this.backUrl});

  final String? frontUrl;
  final String? backUrl;

  static VerificationDocumentUrls parseNationalId(Object? value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) return const VerificationDocumentUrls();
    if (!raw.contains('front:') && !raw.contains('back:')) {
      return VerificationDocumentUrls(frontUrl: raw);
    }

    String? front;
    String? back;
    for (final part in raw.split('|')) {
      final trimmed = part.trim();
      if (trimmed.startsWith('front:')) {
        final candidate = trimmed.substring('front:'.length).trim();
        if (candidate.isNotEmpty) front = candidate;
      } else if (trimmed.startsWith('back:')) {
        final candidate = trimmed.substring('back:'.length).trim();
        if (candidate.isNotEmpty) back = candidate;
      }
    }
    return VerificationDocumentUrls(frontUrl: front, backUrl: back);
  }
}

enum VerificationDashboardStatus { pending, approved, rejected }

class DashboardComplaint {
  const DashboardComplaint({
    required this.id,
    required this.complainantName,
    required this.complainantRole,
    required this.subject,
    required this.message,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  final String id;
  final String complainantName;
  final String complainantRole;
  final String subject;
  final String message;
  final ComplaintDashboardStatus status;
  final ComplaintPriority priority;
  final DateTime? createdAt;
}

enum ComplaintDashboardStatus { open, inReview, archived }

enum ComplaintPriority { low, medium, high }

class DeletedAccountRecord {
  const DeletedAccountRecord({
    required this.id,
    required this.accountName,
    required this.role,
    required this.phone,
    required this.city,
    required this.reason,
    required this.deletedAt,
    required this.deletedBy,
    required this.isSuspicious,
  });

  final String id;
  final String accountName;
  final String role;
  final String phone;
  final String city;
  final String reason;
  final DateTime deletedAt;
  final String deletedBy;
  final bool isSuspicious;
}

class DashboardActivityItem {
  const DashboardActivityItem({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.tone,
  });

  final String title;
  final String description;
  final DateTime createdAt;
  final ActivityTone tone;
}

enum ActivityTone { neutral, success, warning, danger }

class DashboardNotificationSettings {
  const DashboardNotificationSettings({
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
    required this.orderConfirmation,
    required this.orderStatus,
    required this.promotions,
  });

  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool orderConfirmation;
  final bool orderStatus;
  final bool promotions;

  static const defaults = DashboardNotificationSettings(
    pushEnabled: true,
    emailEnabled: true,
    smsEnabled: false,
    orderConfirmation: true,
    orderStatus: true,
    promotions: true,
  );
}
