// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfileServiceModel _$WorkerProfileServiceModelFromJson(
  Map<String, dynamic> json,
) => _WorkerProfileServiceModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
);

Map<String, dynamic> _$WorkerProfileServiceModelToJson(
  _WorkerProfileServiceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'price': instance.price,
  'durationMinutes': instance.durationMinutes,
};
