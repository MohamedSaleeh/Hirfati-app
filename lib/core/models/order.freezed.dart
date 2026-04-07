// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id; String get clientId; String get clientName; String? get clientAvatarUrl; String get workerId; String get workerName; String? get workerAvatarUrl; String? get serviceId; String get serviceTitle; double get price; OrderStatus get status; PaymentStatus get paymentStatus; OrderRequestType get requestType; String get address; double? get latitude; double? get longitude; String? get description; DateTime? get scheduledAt; DateTime? get startedAt; DateTime? get completedAt; DateTime? get paidAt; String? get paymentMethod; String? get paymentTransactionId; double? get distance; double? get rating; DateTime get createdAt;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientAvatarUrl, clientAvatarUrl) || other.clientAvatarUrl == clientAvatarUrl)&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.workerAvatarUrl, workerAvatarUrl) || other.workerAvatarUrl == workerAvatarUrl)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceTitle, serviceTitle) || other.serviceTitle == serviceTitle)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.requestType, requestType) || other.requestType == requestType)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.description, description) || other.description == description)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentTransactionId, paymentTransactionId) || other.paymentTransactionId == paymentTransactionId)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,clientId,clientName,clientAvatarUrl,workerId,workerName,workerAvatarUrl,serviceId,serviceTitle,price,status,paymentStatus,requestType,address,latitude,longitude,description,scheduledAt,startedAt,completedAt,paidAt,paymentMethod,paymentTransactionId,distance,rating,createdAt]);

@override
String toString() {
  return 'Order(id: $id, clientId: $clientId, clientName: $clientName, clientAvatarUrl: $clientAvatarUrl, workerId: $workerId, workerName: $workerName, workerAvatarUrl: $workerAvatarUrl, serviceId: $serviceId, serviceTitle: $serviceTitle, price: $price, status: $status, paymentStatus: $paymentStatus, requestType: $requestType, address: $address, latitude: $latitude, longitude: $longitude, description: $description, scheduledAt: $scheduledAt, startedAt: $startedAt, completedAt: $completedAt, paidAt: $paidAt, paymentMethod: $paymentMethod, paymentTransactionId: $paymentTransactionId, distance: $distance, rating: $rating, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String clientName, String? clientAvatarUrl, String workerId, String workerName, String? workerAvatarUrl, String? serviceId, String serviceTitle, double price, OrderStatus status, PaymentStatus paymentStatus, OrderRequestType requestType, String address, double? latitude, double? longitude, String? description, DateTime? scheduledAt, DateTime? startedAt, DateTime? completedAt, DateTime? paidAt, String? paymentMethod, String? paymentTransactionId, double? distance, double? rating, DateTime createdAt
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? clientName = null,Object? clientAvatarUrl = freezed,Object? workerId = null,Object? workerName = null,Object? workerAvatarUrl = freezed,Object? serviceId = freezed,Object? serviceTitle = null,Object? price = null,Object? status = null,Object? paymentStatus = null,Object? requestType = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? description = freezed,Object? scheduledAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? paidAt = freezed,Object? paymentMethod = freezed,Object? paymentTransactionId = freezed,Object? distance = freezed,Object? rating = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientAvatarUrl: freezed == clientAvatarUrl ? _self.clientAvatarUrl : clientAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,workerName: null == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String,workerAvatarUrl: freezed == workerAvatarUrl ? _self.workerAvatarUrl : workerAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,serviceId: freezed == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String?,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,requestType: null == requestType ? _self.requestType : requestType // ignore: cast_nullable_to_non_nullable
as OrderRequestType,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentTransactionId: freezed == paymentTransactionId ? _self.paymentTransactionId : paymentTransactionId // ignore: cast_nullable_to_non_nullable
as String?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientName,  String? clientAvatarUrl,  String workerId,  String workerName,  String? workerAvatarUrl,  String? serviceId,  String serviceTitle,  double price,  OrderStatus status,  PaymentStatus paymentStatus,  OrderRequestType requestType,  String address,  double? latitude,  double? longitude,  String? description,  DateTime? scheduledAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? paidAt,  String? paymentMethod,  String? paymentTransactionId,  double? distance,  double? rating,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.clientId,_that.clientName,_that.clientAvatarUrl,_that.workerId,_that.workerName,_that.workerAvatarUrl,_that.serviceId,_that.serviceTitle,_that.price,_that.status,_that.paymentStatus,_that.requestType,_that.address,_that.latitude,_that.longitude,_that.description,_that.scheduledAt,_that.startedAt,_that.completedAt,_that.paidAt,_that.paymentMethod,_that.paymentTransactionId,_that.distance,_that.rating,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientName,  String? clientAvatarUrl,  String workerId,  String workerName,  String? workerAvatarUrl,  String? serviceId,  String serviceTitle,  double price,  OrderStatus status,  PaymentStatus paymentStatus,  OrderRequestType requestType,  String address,  double? latitude,  double? longitude,  String? description,  DateTime? scheduledAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? paidAt,  String? paymentMethod,  String? paymentTransactionId,  double? distance,  double? rating,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.clientId,_that.clientName,_that.clientAvatarUrl,_that.workerId,_that.workerName,_that.workerAvatarUrl,_that.serviceId,_that.serviceTitle,_that.price,_that.status,_that.paymentStatus,_that.requestType,_that.address,_that.latitude,_that.longitude,_that.description,_that.scheduledAt,_that.startedAt,_that.completedAt,_that.paidAt,_that.paymentMethod,_that.paymentTransactionId,_that.distance,_that.rating,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String clientName,  String? clientAvatarUrl,  String workerId,  String workerName,  String? workerAvatarUrl,  String? serviceId,  String serviceTitle,  double price,  OrderStatus status,  PaymentStatus paymentStatus,  OrderRequestType requestType,  String address,  double? latitude,  double? longitude,  String? description,  DateTime? scheduledAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? paidAt,  String? paymentMethod,  String? paymentTransactionId,  double? distance,  double? rating,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.clientId,_that.clientName,_that.clientAvatarUrl,_that.workerId,_that.workerName,_that.workerAvatarUrl,_that.serviceId,_that.serviceTitle,_that.price,_that.status,_that.paymentStatus,_that.requestType,_that.address,_that.latitude,_that.longitude,_that.description,_that.scheduledAt,_that.startedAt,_that.completedAt,_that.paidAt,_that.paymentMethod,_that.paymentTransactionId,_that.distance,_that.rating,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, required this.clientId, required this.clientName, this.clientAvatarUrl, required this.workerId, required this.workerName, this.workerAvatarUrl, this.serviceId, required this.serviceTitle, required this.price, required this.status, required this.paymentStatus, required this.requestType, required this.address, this.latitude, this.longitude, this.description, this.scheduledAt, this.startedAt, this.completedAt, this.paidAt, this.paymentMethod, this.paymentTransactionId, this.distance, this.rating, required this.createdAt});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String clientName;
@override final  String? clientAvatarUrl;
@override final  String workerId;
@override final  String workerName;
@override final  String? workerAvatarUrl;
@override final  String? serviceId;
@override final  String serviceTitle;
@override final  double price;
@override final  OrderStatus status;
@override final  PaymentStatus paymentStatus;
@override final  OrderRequestType requestType;
@override final  String address;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? description;
@override final  DateTime? scheduledAt;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;
@override final  DateTime? paidAt;
@override final  String? paymentMethod;
@override final  String? paymentTransactionId;
@override final  double? distance;
@override final  double? rating;
@override final  DateTime createdAt;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientAvatarUrl, clientAvatarUrl) || other.clientAvatarUrl == clientAvatarUrl)&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.workerAvatarUrl, workerAvatarUrl) || other.workerAvatarUrl == workerAvatarUrl)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceTitle, serviceTitle) || other.serviceTitle == serviceTitle)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.requestType, requestType) || other.requestType == requestType)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.description, description) || other.description == description)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentTransactionId, paymentTransactionId) || other.paymentTransactionId == paymentTransactionId)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,clientId,clientName,clientAvatarUrl,workerId,workerName,workerAvatarUrl,serviceId,serviceTitle,price,status,paymentStatus,requestType,address,latitude,longitude,description,scheduledAt,startedAt,completedAt,paidAt,paymentMethod,paymentTransactionId,distance,rating,createdAt]);

@override
String toString() {
  return 'Order(id: $id, clientId: $clientId, clientName: $clientName, clientAvatarUrl: $clientAvatarUrl, workerId: $workerId, workerName: $workerName, workerAvatarUrl: $workerAvatarUrl, serviceId: $serviceId, serviceTitle: $serviceTitle, price: $price, status: $status, paymentStatus: $paymentStatus, requestType: $requestType, address: $address, latitude: $latitude, longitude: $longitude, description: $description, scheduledAt: $scheduledAt, startedAt: $startedAt, completedAt: $completedAt, paidAt: $paidAt, paymentMethod: $paymentMethod, paymentTransactionId: $paymentTransactionId, distance: $distance, rating: $rating, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String clientName, String? clientAvatarUrl, String workerId, String workerName, String? workerAvatarUrl, String? serviceId, String serviceTitle, double price, OrderStatus status, PaymentStatus paymentStatus, OrderRequestType requestType, String address, double? latitude, double? longitude, String? description, DateTime? scheduledAt, DateTime? startedAt, DateTime? completedAt, DateTime? paidAt, String? paymentMethod, String? paymentTransactionId, double? distance, double? rating, DateTime createdAt
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? clientName = null,Object? clientAvatarUrl = freezed,Object? workerId = null,Object? workerName = null,Object? workerAvatarUrl = freezed,Object? serviceId = freezed,Object? serviceTitle = null,Object? price = null,Object? status = null,Object? paymentStatus = null,Object? requestType = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? description = freezed,Object? scheduledAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? paidAt = freezed,Object? paymentMethod = freezed,Object? paymentTransactionId = freezed,Object? distance = freezed,Object? rating = freezed,Object? createdAt = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientAvatarUrl: freezed == clientAvatarUrl ? _self.clientAvatarUrl : clientAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,workerName: null == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String,workerAvatarUrl: freezed == workerAvatarUrl ? _self.workerAvatarUrl : workerAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,serviceId: freezed == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String?,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,requestType: null == requestType ? _self.requestType : requestType // ignore: cast_nullable_to_non_nullable
as OrderRequestType,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentTransactionId: freezed == paymentTransactionId ? _self.paymentTransactionId : paymentTransactionId // ignore: cast_nullable_to_non_nullable
as String?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
