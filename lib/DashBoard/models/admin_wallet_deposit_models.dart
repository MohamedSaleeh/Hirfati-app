class AdminWalletDepositRequest {
  const AdminWalletDepositRequest({
    required this.userId,
    required this.amount,
    required this.reference,
    required this.idempotencyKey,
    this.note,
  });

  final String userId;
  final double amount;
  final String reference;
  final String? note;
  final String idempotencyKey;

  String? validate() {
    if (!amount.isFinite || amount <= 0) return 'invalid_deposit_amount';
    if (reference.trim().isEmpty) return 'missing_external_reference';
    if (idempotencyKey.trim().isEmpty) return 'missing_idempotency_key';
    return null;
  }

  Map<String, dynamic> toRpcParameters() => {
    'p_user_id': userId,
    'p_amount': amount,
    'p_reference': reference.trim(),
    'p_note': note?.trim(),
    'p_idempotency_key': idempotencyKey,
  };
}

class AdminWalletDepositResult {
  const AdminWalletDepositResult({
    required this.success,
    required this.idempotent,
    required this.transactionId,
    required this.transferGroup,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.externalReference,
    required this.createdAt,
  });

  final bool success;
  final bool idempotent;
  final String transactionId;
  final String transferGroup;
  final String userId;
  final double amount;
  final String currency;
  final double balanceBefore;
  final double balanceAfter;
  final String externalReference;
  final DateTime? createdAt;

  factory AdminWalletDepositResult.fromJson(Map<String, dynamic> json) {
    double numeric(String key) =>
        double.tryParse(json[key]?.toString() ?? '') ?? 0;
    return AdminWalletDepositResult(
      success: json['success'] == true,
      idempotent: json['idempotent'] == true,
      transactionId: json['transaction_id']?.toString() ?? '',
      transferGroup: json['transfer_group']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      amount: numeric('amount'),
      currency: json['currency']?.toString() ?? 'USD',
      balanceBefore: numeric('balance_before'),
      balanceAfter: numeric('balance_after'),
      externalReference: json['external_reference']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

class AdminWalletDepositException implements Exception {
  const AdminWalletDepositException(this.code);
  final String code;
}
