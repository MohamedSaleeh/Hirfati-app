// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerServiceModel _$WorkerServiceModelFromJson(Map<String, dynamic> json) =>
    _WorkerServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkerServiceModelToJson(_WorkerServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'durationMinutes': instance.durationMinutes,
    };
