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

class WalletPayment {
  final String id;
  final String? orderId;
  final double amount;
  final String? status;
  final String? paymentMethod;
  final String? transactionId;
  final DateTime? createdAt;
  final DateTime? paidAt;
  final String? userId;
  final String? referenceNumber;
  final double fee;
  final Map<String, dynamic>? metadata;
  final String? idempotencyKey;
  final DateTime? updatedAt;
  final String provider;

  const WalletPayment({
    required this.id,
    this.orderId,
    required this.amount,
    this.status,
    this.paymentMethod,
    this.transactionId,
    this.createdAt,
    this.paidAt,
    this.userId,
    this.referenceNumber,
    required this.fee,
    this.metadata,
    this.idempotencyKey,
    this.updatedAt,
    required this.provider,
  });

  factory WalletPayment.fromJson(Map<String, dynamic> json) {
    return WalletPayment(
      id: json['id']?.toString() ?? '',
      orderId: _stringOrNull(json['order_id']),
      amount: parseWalletNumeric(json['amount']),
      status: _stringOrNull(json['status']),
      paymentMethod: _stringOrNull(json['payment_method']),
      transactionId: _stringOrNull(json['transaction_id']),
      createdAt: parseWalletDate(json['created_at']),
      paidAt: parseWalletDate(json['paid_at']),
      userId: _stringOrNull(json['user_id']),
      referenceNumber: _stringOrNull(json['reference_number']),
      fee: parseWalletNumeric(json['fee']),
      metadata: _mapOrNull(json['metadata']),
      idempotencyKey: _stringOrNull(json['idempotency_key']),
      updatedAt: parseWalletDate(json['updated_at']),
      provider: _stringOrNull(json['provider']) ?? 'sham_cash_mock',
    );
  }

  String get displayStatus {
    final value = status?.trim();
    if (value == null || value.isEmpty) return 'unknown';
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
  final List<WalletPayment> payments;

  const WalletData({
    required this.wallet,
    required this.walletExists,
    required this.payments,
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
