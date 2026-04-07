// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerificationRequestModel _$VerificationRequestModelFromJson(
  Map<String, dynamic> json,
) => _VerificationRequestModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  fullName: json['fullName'] as String,
  age: (json['age'] as num).toInt(),
  email: json['email'] as String,
  nationalIdUrl: json['nationalIdUrl'] as String?,
  passportUrl: json['passportUrl'] as String?,
  driversLicenseUrl: json['driversLicenseUrl'] as String?,
  selfieUrl: json['selfieUrl'] as String?,
  status: $enumDecode(_$VerificationStatusEnumMap, json['status']),
  rejectionReason: json['rejectionReason'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$VerificationRequestModelToJson(
  _VerificationRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'fullName': instance.fullName,
  'age': instance.age,
  'email': instance.email,
  'nationalIdUrl': instance.nationalIdUrl,
  'passportUrl': instance.passportUrl,
  'driversLicenseUrl': instance.driversLicenseUrl,
  'selfieUrl': instance.selfieUrl,
  'status': _$VerificationStatusEnumMap[instance.status]!,
  'rejectionReason': instance.rejectionReason,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.rejected: 'rejected',
};
