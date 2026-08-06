import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

enum PaymentTransactionStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
}

class PaymentSettlementResult {
  final bool success;
  final String paymentId;
  final String orderId;
  final String status;
  final String paymentStatus;
  final String? transactionId;
  final String? referenceNumber;
  final DateTime? paidAt;
  final bool idempotent;

  const PaymentSettlementResult({
    required this.success,
    required this.paymentId,
    required this.orderId,
    required this.status,
    required this.paymentStatus,
    this.transactionId,
    this.referenceNumber,
    this.paidAt,
    required this.idempotent,
  });

  factory PaymentSettlementResult.fromJson(Map<String, dynamic> json) {
    return PaymentSettlementResult(
      success: json['success'] == true,
      paymentId: json['payment_id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      status: json['payment_status']?.toString() ?? 'unknown',
      paymentStatus: json['order_payment_status']?.toString() ?? 'unknown',
      transactionId: json['transaction_id']?.toString(),
      referenceNumber: json['reference_number']?.toString(),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.tryParse(json['paid_at'].toString()),
      idempotent: json['idempotent'] == true,
    );
  }
}

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required double amount,
    required PaymentTransactionStatus status,
    String? paymentMethod,
    String? transactionId,
    DateTime? paidAt,
    required DateTime createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}
