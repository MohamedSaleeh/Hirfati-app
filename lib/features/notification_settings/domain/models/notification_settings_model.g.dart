// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettingsModel _$NotificationSettingsModelFromJson(
  Map<String, dynamic> json,
) => _NotificationSettingsModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  pushEnabled: json['pushEnabled'] as bool? ?? true,
  emailEnabled: json['emailEnabled'] as bool? ?? true,
  smsEnabled: json['smsEnabled'] as bool? ?? false,
  orderConfirmation: json['orderConfirmation'] as bool? ?? true,
  orderStatus: json['orderStatus'] as bool? ?? true,
  promotions: json['promotions'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NotificationSettingsModelToJson(
  _NotificationSettingsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'pushEnabled': instance.pushEnabled,
  'emailEnabled': instance.emailEnabled,
  'smsEnabled': instance.smsEnabled,
  'orderConfirmation': instance.orderConfirmation,
  'orderStatus': instance.orderStatus,
  'promotions': instance.promotions,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
