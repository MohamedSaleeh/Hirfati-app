// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateOrderModel {

 String? get workerId; String? get serviceId; String? get serviceTitle; double? get servicePrice; int? get serviceDurationMinutes; String get categoryId; String get categoryName; String get description; List<OrderPhotoModel> get photos; String? get address; double? get latitude; double? get longitude; DateTime? get scheduledDate;@JsonKey(includeFromJson: false, includeToJson: false) TimeOfDay? get scheduledTime; String get preferredTimeSlot; String get accessInstructions; double get estimatedPrice; double get price;
/// Create a copy of CreateOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOrderModelCopyWith<CreateOrderModel> get copyWith => _$CreateOrderModelCopyWithImpl<CreateOrderModel>(this as CreateOrderModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOrderModel&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceTitle, serviceTitle) || other.serviceTitle == serviceTitle)&&(identical(other.servicePrice, servicePrice) || other.servicePrice == servicePrice)&&(identical(other.serviceDurationMinutes, serviceDurationMinutes) || other.serviceDurationMinutes == serviceDurationMinutes)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.preferredTimeSlot, preferredTimeSlot) || other.preferredTimeSlot == preferredTimeSlot)&&(identical(other.accessInstructions, accessInstructions) || other.accessInstructions == accessInstructions)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,workerId,serviceId,serviceTitle,servicePrice,serviceDurationMinutes,categoryId,categoryName,description,const DeepCollectionEquality().hash(photos),address,latitude,longitude,scheduledDate,scheduledTime,preferredTimeSlot,accessInstructions,estimatedPrice,price);

@override
String toString() {
  return 'CreateOrderModel(workerId: $workerId, serviceId: $serviceId, serviceTitle: $serviceTitle, servicePrice: $servicePrice, serviceDurationMinutes: $serviceDurationMinutes, categoryId: $categoryId, categoryName: $categoryName, description: $description, photos: $photos, address: $address, latitude: $latitude, longitude: $longitude, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, preferredTimeSlot: $preferredTimeSlot, accessInstructions: $accessInstructions, estimatedPrice: $estimatedPrice, price: $price)';
}


}

/// @nodoc
abstract mixin class $CreateOrderModelCopyWith<$Res>  {
  factory $CreateOrderModelCopyWith(CreateOrderModel value, $Res Function(CreateOrderModel) _then) = _$CreateOrderModelCopyWithImpl;
@useResult
$Res call({
 String? workerId, String? serviceId, String? serviceTitle, double? servicePrice, int? serviceDurationMinutes, String categoryId, String categoryName, String description, List<OrderPhotoModel> photos, String? address, double? latitude, double? longitude, DateTime? scheduledDate,@JsonKey(includeFromJson: false, includeToJson: false) TimeOfDay? scheduledTime, String preferredTimeSlot, String accessInstructions, double estimatedPrice, double price
});




}
/// @nodoc
class _$CreateOrderModelCopyWithImpl<$Res>
    implements $CreateOrderModelCopyWith<$Res> {
  _$CreateOrderModelCopyWithImpl(this._self, this._then);

  final CreateOrderModel _self;
  final $Res Function(CreateOrderModel) _then;

/// Create a copy of CreateOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workerId = freezed,Object? serviceId = freezed,Object? serviceTitle = freezed,Object? servicePrice = freezed,Object? serviceDurationMinutes = freezed,Object? categoryId = null,Object? categoryName = null,Object? description = null,Object? photos = null,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? scheduledDate = freezed,Object? scheduledTime = freezed,Object? preferredTimeSlot = null,Object? accessInstructions = null,Object? estimatedPrice = null,Object? price = null,}) {
  return _then(_self.copyWith(
workerId: freezed == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String?,serviceId: freezed == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String?,serviceTitle: freezed == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String?,servicePrice: freezed == servicePrice ? _self.servicePrice : servicePrice // ignore: cast_nullable_to_non_nullable
as double?,serviceDurationMinutes: freezed == serviceDurationMinutes ? _self.serviceDurationMinutes : serviceDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<OrderPhotoModel>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,preferredTimeSlot: null == preferredTimeSlot ? _self.preferredTimeSlot : preferredTimeSlot // ignore: cast_nullable_to_non_nullable
as String,accessInstructions: null == accessInstructions ? _self.accessInstructions : accessInstructions // ignore: cast_nullable_to_non_nullable
as String,estimatedPrice: null == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOrderModel].
extension CreateOrderModelPatterns on CreateOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _CreateOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? workerId,  String? serviceId,  String? serviceTitle,  double? servicePrice,  int? serviceDurationMinutes,  String categoryId,  String categoryName,  String description,  List<OrderPhotoModel> photos,  String? address,  double? latitude,  double? longitude,  DateTime? scheduledDate, @JsonKey(includeFromJson: false, includeToJson: false)  TimeOfDay? scheduledTime,  String preferredTimeSlot,  String accessInstructions,  double estimatedPrice,  double price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOrderModel() when $default != null:
return $default(_that.workerId,_that.serviceId,_that.serviceTitle,_that.servicePrice,_that.serviceDurationMinutes,_that.categoryId,_that.categoryName,_that.description,_that.photos,_that.address,_that.latitude,_that.longitude,_that.scheduledDate,_that.scheduledTime,_that.preferredTimeSlot,_that.accessInstructions,_that.estimatedPrice,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? workerId,  String? serviceId,  String? serviceTitle,  double? servicePrice,  int? serviceDurationMinutes,  String categoryId,  String categoryName,  String description,  List<OrderPhotoModel> photos,  String? address,  double? latitude,  double? longitude,  DateTime? scheduledDate, @JsonKey(includeFromJson: false, includeToJson: false)  TimeOfDay? scheduledTime,  String preferredTimeSlot,  String accessInstructions,  double estimatedPrice,  double price)  $default,) {final _that = this;
switch (_that) {
case _CreateOrderModel():
return $default(_that.workerId,_that.serviceId,_that.serviceTitle,_that.servicePrice,_that.serviceDurationMinutes,_that.categoryId,_that.categoryName,_that.description,_that.photos,_that.address,_that.latitude,_that.longitude,_that.scheduledDate,_that.scheduledTime,_that.preferredTimeSlot,_that.accessInstructions,_that.estimatedPrice,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? workerId,  String? serviceId,  String? serviceTitle,  double? servicePrice,  int? serviceDurationMinutes,  String categoryId,  String categoryName,  String description,  List<OrderPhotoModel> photos,  String? address,  double? latitude,  double? longitude,  DateTime? scheduledDate, @JsonKey(includeFromJson: false, includeToJson: false)  TimeOfDay? scheduledTime,  String preferredTimeSlot,  String accessInstructions,  double estimatedPrice,  double price)?  $default,) {final _that = this;
switch (_that) {
case _CreateOrderModel() when $default != null:
return $default(_that.workerId,_that.serviceId,_that.serviceTitle,_that.servicePrice,_that.serviceDurationMinutes,_that.categoryId,_that.categoryName,_that.description,_that.photos,_that.address,_that.latitude,_that.longitude,_that.scheduledDate,_that.scheduledTime,_that.preferredTimeSlot,_that.accessInstructions,_that.estimatedPrice,_that.price);case _:
  return null;

}
}

}

/// @nodoc


class _CreateOrderModel extends CreateOrderModel {
  const _CreateOrderModel({this.workerId, this.serviceId, this.serviceTitle, this.servicePrice, this.serviceDurationMinutes, this.categoryId = '', this.categoryName = '', this.description = '', final  List<OrderPhotoModel> photos = const <OrderPhotoModel>[], this.address, this.latitude, this.longitude, this.scheduledDate, @JsonKey(includeFromJson: false, includeToJson: false) this.scheduledTime, this.preferredTimeSlot = 'morning', this.accessInstructions = '', this.estimatedPrice = 0, this.price = 0}): _photos = photos,super._();
  

@override final  String? workerId;
@override final  String? serviceId;
@override final  String? serviceTitle;
@override final  double? servicePrice;
@override final  int? serviceDurationMinutes;
@override@JsonKey() final  String categoryId;
@override@JsonKey() final  String categoryName;
@override@JsonKey() final  String description;
 final  List<OrderPhotoModel> _photos;
@override@JsonKey() List<OrderPhotoModel> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  String? address;
@override final  double? latitude;
@override final  double? longitude;
@override final  DateTime? scheduledDate;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  TimeOfDay? scheduledTime;
@override@JsonKey() final  String preferredTimeSlot;
@override@JsonKey() final  String accessInstructions;
@override@JsonKey() final  double estimatedPrice;
@override@JsonKey() final  double price;

/// Create a copy of CreateOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOrderModelCopyWith<_CreateOrderModel> get copyWith => __$CreateOrderModelCopyWithImpl<_CreateOrderModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOrderModel&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceTitle, serviceTitle) || other.serviceTitle == serviceTitle)&&(identical(other.servicePrice, servicePrice) || other.servicePrice == servicePrice)&&(identical(other.serviceDurationMinutes, serviceDurationMinutes) || other.serviceDurationMinutes == serviceDurationMinutes)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.preferredTimeSlot, preferredTimeSlot) || other.preferredTimeSlot == preferredTimeSlot)&&(identical(other.accessInstructions, accessInstructions) || other.accessInstructions == accessInstructions)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,workerId,serviceId,serviceTitle,servicePrice,serviceDurationMinutes,categoryId,categoryName,description,const DeepCollectionEquality().hash(_photos),address,latitude,longitude,scheduledDate,scheduledTime,preferredTimeSlot,accessInstructions,estimatedPrice,price);

@override
String toString() {
  return 'CreateOrderModel(workerId: $workerId, serviceId: $serviceId, serviceTitle: $serviceTitle, servicePrice: $servicePrice, serviceDurationMinutes: $serviceDurationMinutes, categoryId: $categoryId, categoryName: $categoryName, description: $description, photos: $photos, address: $address, latitude: $latitude, longitude: $longitude, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, preferredTimeSlot: $preferredTimeSlot, accessInstructions: $accessInstructions, estimatedPrice: $estimatedPrice, price: $price)';
}


}

/// @nodoc
abstract mixin class _$CreateOrderModelCopyWith<$Res> implements $CreateOrderModelCopyWith<$Res> {
  factory _$CreateOrderModelCopyWith(_CreateOrderModel value, $Res Function(_CreateOrderModel) _then) = __$CreateOrderModelCopyWithImpl;
@override @useResult
$Res call({
 String? workerId, String? serviceId, String? serviceTitle, double? servicePrice, int? serviceDurationMinutes, String categoryId, String categoryName, String description, List<OrderPhotoModel> photos, String? address, double? latitude, double? longitude, DateTime? scheduledDate,@JsonKey(includeFromJson: false, includeToJson: false) TimeOfDay? scheduledTime, String preferredTimeSlot, String accessInstructions, double estimatedPrice, double price
});




}
/// @nodoc
class __$CreateOrderModelCopyWithImpl<$Res>
    implements _$CreateOrderModelCopyWith<$Res> {
  __$CreateOrderModelCopyWithImpl(this._self, this._then);

  final _CreateOrderModel _self;
  final $Res Function(_CreateOrderModel) _then;

/// Create a copy of CreateOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workerId = freezed,Object? serviceId = freezed,Object? serviceTitle = freezed,Object? servicePrice = freezed,Object? serviceDurationMinutes = freezed,Object? categoryId = null,Object? categoryName = null,Object? description = null,Object? photos = null,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? scheduledDate = freezed,Object? scheduledTime = freezed,Object? preferredTimeSlot = null,Object? accessInstructions = null,Object? estimatedPrice = null,Object? price = null,}) {
  return _then(_CreateOrderModel(
workerId: freezed == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String?,serviceId: freezed == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String?,serviceTitle: freezed == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String?,servicePrice: freezed == servicePrice ? _self.servicePrice : servicePrice // ignore: cast_nullable_to_non_nullable
as double?,serviceDurationMinutes: freezed == serviceDurationMinutes ? _self.serviceDurationMinutes : serviceDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<OrderPhotoModel>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,preferredTimeSlot: null == preferredTimeSlot ? _self.preferredTimeSlot : preferredTimeSlot // ignore: cast_nullable_to_non_nullable
as String,accessInstructions: null == accessInstructions ? _self.accessInstructions : accessInstructions // ignore: cast_nullable_to_non_nullable
as String,estimatedPrice: null == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
