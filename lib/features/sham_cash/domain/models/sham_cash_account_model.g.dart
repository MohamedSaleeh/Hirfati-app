// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sham_cash_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShamCashAccountModel _$ShamCashAccountModelFromJson(
  Map<String, dynamic> json,
) => _ShamCashAccountModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  accountCode: json['accountCode'] as String,
  balance: (json['balance'] as num).toDouble(),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ShamCashAccountModelToJson(
  _ShamCashAccountModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'accountCode': instance.accountCode,
  'balance': instance.balance,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};
