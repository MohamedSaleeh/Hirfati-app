// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportMessageModel _$SupportMessageModelFromJson(Map<String, dynamic> json) =>
    _SupportMessageModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      subject: json['subject'] as String?,
      isResolved: json['isResolved'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SupportMessageModelToJson(
  _SupportMessageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'message': instance.message,
  'subject': instance.subject,
  'isResolved': instance.isResolved,
  'createdAt': instance.createdAt?.toIso8601String(),
};
