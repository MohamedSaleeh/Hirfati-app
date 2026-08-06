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

class PaymentSettlementResult {
  final bool success;
  final bool idempotent;
  final String? paymentId;
  final String? orderId;
  final String? paymentStatus;
  final String? orderPaymentStatus;
  final String? transactionId;
  final String? referenceNumber;
  final DateTime? paidAt;

  const PaymentSettlementResult({
    required this.success,
    required this.idempotent,
    this.paymentId,
    this.orderId,
    this.paymentStatus,
    this.orderPaymentStatus,
    this.transactionId,
    this.referenceNumber,
    this.paidAt,
  });

  factory PaymentSettlementResult.fromJson(Map<String, dynamic> json) {
    return PaymentSettlementResult(
      success: json['success'] == true,
      idempotent: json['idempotent'] == true,
      paymentId: json['payment_id']?.toString(),
      orderId: json['order_id']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      orderPaymentStatus: json['order_payment_status']?.toString(),
      transactionId: json['transaction_id']?.toString(),
      referenceNumber: json['reference_number']?.toString(),
      paidAt: DateTime.tryParse(json['paid_at']?.toString() ?? ''),
    );
  }
}

class PaymentException implements Exception {
  final String code;
  final String message;

  const PaymentException(this.code, this.message);

  @override
  String toString() => message;
}
