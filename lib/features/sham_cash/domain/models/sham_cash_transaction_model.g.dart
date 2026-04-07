// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sham_cash_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShamCashTransactionModel _$ShamCashTransactionModelFromJson(
  Map<String, dynamic> json,
) => _ShamCashTransactionModel(
  id: json['id'] as String,
  fromUserId: json['fromUserId'] as String?,
  toUserId: json['toUserId'] as String?,
  amount: (json['amount'] as num).toDouble(),
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
  reference: json['reference'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  fromUserName: json['fromUserName'] as String?,
  toUserName: json['toUserName'] as String?,
);

Map<String, dynamic> _$ShamCashTransactionModelToJson(
  _ShamCashTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fromUserId': instance.fromUserId,
  'toUserId': instance.toUserId,
  'amount': instance.amount,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'status': _$TransactionStatusEnumMap[instance.status]!,
  'reference': instance.reference,
  'createdAt': instance.createdAt.toIso8601String(),
  'fromUserName': instance.fromUserName,
  'toUserName': instance.toUserName,
};

const _$TransactionTypeEnumMap = {
  TransactionType.deposit: 'deposit',
  TransactionType.payment: 'payment',
  TransactionType.transfer: 'transfer',
  TransactionType.withdraw: 'withdraw',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.success: 'success',
  TransactionStatus.failed: 'failed',
};
