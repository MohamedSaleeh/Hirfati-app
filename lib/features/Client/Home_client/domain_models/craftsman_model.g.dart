// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'craftsman_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CraftsmanModel _$CraftsmanModelFromJson(Map<String, dynamic> json) =>
    _CraftsmanModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String?,
      categoryId: json['categoryId'] as String?,
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      profession: json['profession'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      hourlyPrice: (json['hourlyPrice'] as num?)?.toDouble() ?? 0.0,
      minServicePrice: (json['minServicePrice'] as num?)?.toDouble() ?? 0.0,
      hasServices: json['hasServices'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      city: json['city'] as String?,
    );

Map<String, dynamic> _$CraftsmanModelToJson(_CraftsmanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'categoryId': instance.categoryId,
      'category': instance.category,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'profession': instance.profession,
      'rating': instance.rating,
      'distance': instance.distance,
      'hourlyPrice': instance.hourlyPrice,
      'minServicePrice': instance.minServicePrice,
      'hasServices': instance.hasServices,
      'isNew': instance.isNew,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
    };
