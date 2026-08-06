class WalletAccount {
  final String userId;
  final double balance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WalletAccount({
    required this.userId,
    required this.balance,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) {
    return WalletAccount(
      userId: json['user_id']?.toString() ?? '',
      balance: parseWalletNumeric(json['balance']),
      createdAt: parseWalletDate(json['created_at']),
      updatedAt: parseWalletDate(json['updated_at']),
    );
  }

  factory WalletAccount.empty(String userId) {
    return WalletAccount(userId: userId, balance: 0);
  }
}

class WalletTransaction {
  final String id;
  final String walletUserId;
  final String? counterpartyUserId;
  final String? paymentId;
  final String? orderId;
  final String transactionType;
  final String direction;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String status;
  final String? transferGroup;
  final String currency;
  final String? title;
  final String? description;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  const WalletTransaction({
    required this.id,
    required this.walletUserId,
    this.counterpartyUserId,
    this.paymentId,
    this.orderId,
    required this.transactionType,
    required this.direction,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.status,
    this.transferGroup,
    required this.currency,
    this.title,
    this.description,
    this.createdAt,
    this.metadata,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      walletUserId: json['wallet_user_id']?.toString() ?? '',
      counterpartyUserId: _stringOrNull(json['counterparty_user_id']),
      paymentId: _stringOrNull(json['payment_id']),
      orderId: _stringOrNull(json['order_id']),
      transactionType: _stringOrNull(json['transaction_type']) ?? 'payment',
      direction: _stringOrNull(json['direction']) ?? 'debit',
      amount: parseWalletNumeric(json['amount']),
      balanceBefore: parseWalletNumeric(json['balance_before']),
      balanceAfter: parseWalletNumeric(json['balance_after']),
      status: _stringOrNull(json['status']) ?? 'pending',
      transferGroup: _stringOrNull(json['transfer_group']),
      currency: _stringOrNull(json['currency']) ?? 'SYP',
      title: _stringOrNull(json['title']),
      description: _stringOrNull(json['description']),
      createdAt: parseWalletDate(json['created_at']),
      metadata: _mapOrNull(json['metadata']),
    );
  }

  String? get paymentMethod => transactionType;
  String? get transactionId => transferGroup;
  DateTime? get paidAt => status == 'completed' ? createdAt : null;
  String? get referenceNumber => transferGroup;
  double get fee => 0;
  String get provider => 'wallet';

  String get displayStatus {
    final value = status.trim();
    if (value.isEmpty) return 'unknown';
    return value;
  }
}

class WalletPaymentEvent {
  final String id;
  final String? paymentId;
  final String eventType;
  final Map<String, dynamic>? eventData;
  final DateTime? createdAt;
  final String? createdBy;

  const WalletPaymentEvent({
    required this.id,
    this.paymentId,
    required this.eventType,
    this.eventData,
    this.createdAt,
    this.createdBy,
  });

  factory WalletPaymentEvent.fromJson(Map<String, dynamic> json) {
    return WalletPaymentEvent(
      id: json['id']?.toString() ?? '',
      paymentId: _stringOrNull(json['payment_id']),
      eventType: _stringOrNull(json['event_type']) ?? 'unknown',
      eventData: _mapOrNull(json['event_data']),
      createdAt: parseWalletDate(json['created_at']),
      createdBy: _stringOrNull(json['created_by']),
    );
  }
}

class WalletData {
  final WalletAccount wallet;
  final bool walletExists;
  final List<WalletTransaction> transactions;

  const WalletData({
    required this.wallet,
    required this.walletExists,
    required this.transactions,
  });
}

double parseWalletNumeric(Object? value, [double fallback = 0]) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  if (value is String) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) return fallback;
    return double.tryParse(normalized) ?? fallback;
  }
  return fallback;
}

DateTime? parseWalletDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    return DateTime.tryParse(normalized);
  }
  return null;
}

Map<String, String> safeWalletMetadataFields(Map<String, dynamic>? metadata) {
  if (metadata == null || metadata.isEmpty) return const {};

  final fields = <String, String>{};
  for (final entry in metadata.entries) {
    final key = entry.key.trim();
    if (!_isSafeMetadataKey(key)) continue;

    final value = entry.value;
    if (value == null) continue;
    if (value is String && value.trim().isEmpty) continue;
    if (value is Map || value is Iterable) continue;

    fields[key] = value.toString();
  }

  return fields;
}

String? _stringOrNull(Object? value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

Map<String, dynamic>? _mapOrNull(Object? value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

bool _isSafeMetadataKey(String key) {
  final normalized = key.toLowerCase();
  const blockedFragments = [
    'token',
    'secret',
    'pin',
    'password',
    'auth',
    'jwt',
    'bearer',
    'service_role',
    'session',
    'card',
    'cvv',
    'key',
    'debug',
    'stack',
    'error',
  ];

  if (blockedFragments.any(normalized.contains)) return false;

  const allowedKeys = {
    'amount',
    'fee',
    'order_id',
    'payment_method',
    'provider',
    'reason',
    'reference_number',
    'status',
    'transaction_id',
  };

  return allowedKeys.contains(normalized);
}
