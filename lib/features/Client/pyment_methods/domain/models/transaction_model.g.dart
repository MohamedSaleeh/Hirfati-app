// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      orderId: json['orderId'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'category': instance.category,
      'price': instance.price,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'orderId': instance.orderId,
    };

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.completed: 'completed',
  TransactionStatus.cancelled: 'cancelled',
  TransactionStatus.refunded: 'refunded',
};
