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

  List<DashboardComplaint> get urgentComplaints => complaints
      .where((complaint) =>
          complaint.priority == ComplaintPriority.high &&
          complaint.status != ComplaintDashboardStatus.archived)
      .take(3)
      .toList();
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
