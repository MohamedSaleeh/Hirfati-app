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
  final String? payerId;
  final String? payeeId;
  final String? transferGroup;
  final String? parentPaymentId;
  final String? referenceNumber;
  final double fee;
  final Map<String, dynamic>? metadata;
  final String? idempotencyKey;
  final DateTime? updatedAt;
  final String provider;
  final String currency;
  final String? createdBy;

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
    this.payerId,
    this.payeeId,
    this.transferGroup,
    this.parentPaymentId,
    this.referenceNumber,
    required this.fee,
    this.metadata,
    this.idempotencyKey,
    this.updatedAt,
    required this.provider,
    this.currency = 'SYP',
    this.createdBy,
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
      userId: _stringOrNull(json['user_id']) ?? _stringOrNull(json['payer_id']),
      payerId:
          _stringOrNull(json['payer_id']) ?? _stringOrNull(json['user_id']),
      payeeId: _stringOrNull(json['payee_id']),
      transferGroup: _stringOrNull(json['transfer_group']),
      parentPaymentId: _stringOrNull(json['parent_payment_id']),
      referenceNumber: _stringOrNull(json['reference_number']),
      fee: parseWalletNumeric(json['fee']),
      metadata: _mapOrNull(json['metadata']),
      idempotencyKey: _stringOrNull(json['idempotency_key']),
      updatedAt: parseWalletDate(json['updated_at']),
      provider: _stringOrNull(json['provider']) ?? 'wallet',
      currency: _stringOrNull(json['currency']) ?? 'SYP',
      createdBy: _stringOrNull(json['created_by']),
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

class WalletTransaction {
  final String id;
  final String walletUserId;
  final String direction;
  final String transactionType;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String status;
  final String? orderId;
  final String? paymentId;
  final String? withdrawalId;
  final String? counterpartyUserId;
  final String? relatedTransactionId;
  final String? transferGroup;
  final String idempotencyKey;
  final String? title;
  final String? description;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final String? createdBy;
  final String? createdByUserId;
  final String currency;

  const WalletTransaction({
    required this.id,
    required this.walletUserId,
    required this.direction,
    required this.transactionType,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.status,
    this.orderId,
    this.paymentId,
    this.withdrawalId,
    this.counterpartyUserId,
    this.relatedTransactionId,
    this.transferGroup,
    required this.idempotencyKey,
    this.title,
    this.description,
    this.metadata,
    this.createdAt,
    this.createdBy,
    this.createdByUserId,
    this.currency = 'SYP',
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      walletUserId: json['wallet_user_id']?.toString() ?? '',
      direction: _stringOrNull(json['direction']) ?? 'credit',
      transactionType: _stringOrNull(json['transaction_type']) ?? 'unknown',
      amount: parseWalletNumeric(json['amount']),
      balanceBefore: parseWalletNumeric(json['balance_before']),
      balanceAfter: parseWalletNumeric(json['balance_after']),
      status: _stringOrNull(json['status']) ?? 'completed',
      orderId: _stringOrNull(json['order_id']),
      paymentId: _stringOrNull(json['payment_id']),
      withdrawalId: _stringOrNull(json['withdrawal_id']),
      counterpartyUserId: _stringOrNull(json['counterparty_user_id']),
      relatedTransactionId: _stringOrNull(json['related_transaction_id']),
      transferGroup: _stringOrNull(
        json['transfer_group'] ?? json['transfer_group_id'],
      ),
      idempotencyKey: _stringOrNull(json['idempotency_key']) ?? '',
      title: _stringOrNull(json['title']),
      description: _stringOrNull(json['description']),
      metadata: _mapOrNull(json['metadata']),
      createdAt: parseWalletDate(json['created_at']),
      createdBy: _stringOrNull(json['created_by']),
      createdByUserId: _stringOrNull(json['created_by_user_id']),
      currency: _stringOrNull(json['currency']) ?? 'SYP',
    );
  }

  bool get isCredit => direction.toLowerCase() == 'credit';
  bool get isDebit => direction.toLowerCase() == 'debit';

  double get signedAmount => isDebit ? -amount : amount;

  String get displayStatus {
    final value = status.trim();
    if (value.isEmpty) return 'unknown';
    return value;
  }

  String get displayTitle {
    final value = title?.trim();
    if (value != null && value.isNotEmpty) return value;
    return transactionType;
  }
}

class WalletData {
  final WalletAccount wallet;
  final bool walletExists;
  final List<WalletPayment> payments;
  final List<WalletTransaction> transactions;

  const WalletData({
    required this.wallet,
    required this.walletExists,
    required this.payments,
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
    'transfer_group',
    'currency',
  };

  return allowedKeys.contains(normalized);
}
