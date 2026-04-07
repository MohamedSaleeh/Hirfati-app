// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfileReviewModel _$WorkerProfileReviewModelFromJson(
  Map<String, dynamic> json,
) => _WorkerProfileReviewModel(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  clientName: json['clientName'] as String,
  clientAvatarUrl: json['clientAvatarUrl'] as String?,
  rating: (json['rating'] as num).toDouble(),
  comment: json['comment'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$WorkerProfileReviewModelToJson(
  _WorkerProfileReviewModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'clientName': instance.clientName,
  'clientAvatarUrl': instance.clientAvatarUrl,
  'rating': instance.rating,
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
};
