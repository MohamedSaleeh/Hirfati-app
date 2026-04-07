// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PinModel _$PinModelFromJson(Map<String, dynamic> json) => _PinModel(
  userId: json['userId'] as String,
  pin: json['pin'] as String,
  isSet: json['isSet'] as bool? ?? false,
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  lastAttemptAt: json['lastAttemptAt'] == null
      ? null
      : DateTime.parse(json['lastAttemptAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PinModelToJson(_PinModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'pin': instance.pin,
  'isSet': instance.isSet,
  'attempts': instance.attempts,
  'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
