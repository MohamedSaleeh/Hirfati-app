// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  orderId: json['orderId'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'USD',
  status: $enumDecode(_$PaymentTransactionStatusEnumMap, json['status']),
  paymentMethod: json['paymentMethod'] as String?,
  transactionId: json['transactionId'] as String?,
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'amount': instance.amount,
  'currency': instance.currency,
  'status': _$PaymentTransactionStatusEnumMap[instance.status]!,
  'paymentMethod': instance.paymentMethod,
  'transactionId': instance.transactionId,
  'paidAt': instance.paidAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$PaymentTransactionStatusEnumMap = {
  PaymentTransactionStatus.pending: 'pending',
  PaymentTransactionStatus.processing: 'processing',
  PaymentTransactionStatus.completed: 'completed',
  PaymentTransactionStatus.failed: 'failed',
  PaymentTransactionStatus.refunded: 'refunded',
};
