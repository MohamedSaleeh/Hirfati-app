// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      id: json['id'] as String?,
      label: json['label'] as String,
      addressType: $enumDecode(_$AddressTypeEnumMap, json['type']),
      fullAddress: json['full_address'] as String,
      street: json['street'] as String?,
      city: json['city'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': _$AddressTypeEnumMap[instance.addressType]!,
      'full_address': instance.fullAddress,
      'street': instance.street,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_default': instance.isDefault,
      'user_id': instance.userId,
    };

const _$AddressTypeEnumMap = {
  AddressType.home: 'home',
  AddressType.office: 'office',
  AddressType.other: 'other',
};
