// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    _PaymentMethodModel(
      id: json['id'] as String,
      cardType: $enumDecode(_$CardTypeEnumMap, json['cardType']),
      last4: json['last4'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      cardholderName: json['cardholderName'] as String?,
    );

Map<String, dynamic> _$PaymentMethodModelToJson(_PaymentMethodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardType': _$CardTypeEnumMap[instance.cardType]!,
      'last4': instance.last4,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'isDefault': instance.isDefault,
      'cardholderName': instance.cardholderName,
    };

const _$CardTypeEnumMap = {
  CardType.visa: 'visa',
  CardType.mastercard: 'mastercard',
  CardType.amex: 'amex',
  CardType.discover: 'discover',
};
