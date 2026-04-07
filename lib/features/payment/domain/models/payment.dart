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

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}