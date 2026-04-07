// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  clientName: json['clientName'] as String,
  clientAvatarUrl: json['clientAvatarUrl'] as String?,
  workerId: json['workerId'] as String,
  workerName: json['workerName'] as String,
  workerAvatarUrl: json['workerAvatarUrl'] as String?,
  serviceId: json['serviceId'] as String?,
  serviceTitle: json['serviceTitle'] as String,
  price: (json['price'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
  requestType: $enumDecode(_$OrderRequestTypeEnumMap, json['requestType']),
  address: json['address'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  description: json['description'] as String?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
  paymentMethod: json['paymentMethod'] as String?,
  paymentTransactionId: json['paymentTransactionId'] as String?,
  distance: (json['distance'] as num?)?.toDouble(),
  rating: (json['rating'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'clientName': instance.clientName,
  'clientAvatarUrl': instance.clientAvatarUrl,
  'workerId': instance.workerId,
  'workerName': instance.workerName,
  'workerAvatarUrl': instance.workerAvatarUrl,
  'serviceId': instance.serviceId,
  'serviceTitle': instance.serviceTitle,
  'price': instance.price,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'requestType': _$OrderRequestTypeEnumMap[instance.requestType]!,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'description': instance.description,
  'scheduledAt': instance.scheduledAt?.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'paidAt': instance.paidAt?.toIso8601String(),
  'paymentMethod': instance.paymentMethod,
  'paymentTransactionId': instance.paymentTransactionId,
  'distance': instance.distance,
  'rating': instance.rating,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.accepted: 'accepted',
  OrderStatus.in_progress: 'in_progress',
  OrderStatus.completed: 'completed',
  OrderStatus.rejected: 'rejected',
  OrderStatus.cancelled: 'cancelled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};

const _$OrderRequestTypeEnumMap = {
  OrderRequestType.immediate: 'immediate',
  OrderRequestType.scheduled: 'scheduled',
};
