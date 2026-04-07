// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettingsModel {

 String get id; String get userId; bool get pushEnabled; bool get emailEnabled; bool get smsEnabled; bool get orderConfirmation; bool get orderStatus; bool get promotions; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of NotificationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsModelCopyWith<NotificationSettingsModel> get copyWith => _$NotificationSettingsModelCopyWithImpl<NotificationSettingsModel>(this as NotificationSettingsModel, _$identity);

  /// Serializes this NotificationSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.smsEnabled, smsEnabled) || other.smsEnabled == smsEnabled)&&(identical(other.orderConfirmation, orderConfirmation) || other.orderConfirmation == orderConfirmation)&&(identical(other.orderStatus, orderStatus) || other.orderStatus == orderStatus)&&(identical(other.promotions, promotions) || other.promotions == promotions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,pushEnabled,emailEnabled,smsEnabled,orderConfirmation,orderStatus,promotions,createdAt,updatedAt);

@override
String toString() {
  return 'NotificationSettingsModel(id: $id, userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, smsEnabled: $smsEnabled, orderConfirmation: $orderConfirmation, orderStatus: $orderStatus, promotions: $promotions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsModelCopyWith<$Res>  {
  factory $NotificationSettingsModelCopyWith(NotificationSettingsModel value, $Res Function(NotificationSettingsModel) _then) = _$NotificationSettingsModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, bool pushEnabled, bool emailEnabled, bool smsEnabled, bool orderConfirmation, bool orderStatus, bool promotions, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$NotificationSettingsModelCopyWithImpl<$Res>
    implements $NotificationSettingsModelCopyWith<$Res> {
  _$NotificationSettingsModelCopyWithImpl(this._self, this._then);

  final NotificationSettingsModel _self;
  final $Res Function(NotificationSettingsModel) _then;

/// Create a copy of NotificationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? pushEnabled = null,Object? emailEnabled = null,Object? smsEnabled = null,Object? orderConfirmation = null,Object? orderStatus = null,Object? promotions = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,smsEnabled: null == smsEnabled ? _self.smsEnabled : smsEnabled // ignore: cast_nullable_to_non_nullable
as bool,orderConfirmation: null == orderConfirmation ? _self.orderConfirmation : orderConfirmation // ignore: cast_nullable_to_non_nullable
as bool,orderStatus: null == orderStatus ? _self.orderStatus : orderStatus // ignore: cast_nullable_to_non_nullable
as bool,promotions: null == promotions ? _self.promotions : promotions // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSettingsModel].
extension NotificationSettingsModelPatterns on NotificationSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  bool pushEnabled,  bool emailEnabled,  bool smsEnabled,  bool orderConfirmation,  bool orderStatus,  bool promotions,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSettingsModel() when $default != null:
return $default(_that.id,_that.userId,_that.pushEnabled,_that.emailEnabled,_that.smsEnabled,_that.orderConfirmation,_that.orderStatus,_that.promotions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  bool pushEnabled,  bool emailEnabled,  bool smsEnabled,  bool orderConfirmation,  bool orderStatus,  bool promotions,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationSettingsModel():
return $default(_that.id,_that.userId,_that.pushEnabled,_that.emailEnabled,_that.smsEnabled,_that.orderConfirmation,_that.orderStatus,_that.promotions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  bool pushEnabled,  bool emailEnabled,  bool smsEnabled,  bool orderConfirmation,  bool orderStatus,  bool promotions,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSettingsModel() when $default != null:
return $default(_that.id,_that.userId,_that.pushEnabled,_that.emailEnabled,_that.smsEnabled,_that.orderConfirmation,_that.orderStatus,_that.promotions,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSettingsModel implements NotificationSettingsModel {
  const _NotificationSettingsModel({required this.id, required this.userId, this.pushEnabled = true, this.emailEnabled = true, this.smsEnabled = false, this.orderConfirmation = true, this.orderStatus = true, this.promotions = true, this.createdAt, this.updatedAt});
  factory _NotificationSettingsModel.fromJson(Map<String, dynamic> json) => _$NotificationSettingsModelFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  bool pushEnabled;
@override@JsonKey() final  bool emailEnabled;
@override@JsonKey() final  bool smsEnabled;
@override@JsonKey() final  bool orderConfirmation;
@override@JsonKey() final  bool orderStatus;
@override@JsonKey() final  bool promotions;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of NotificationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsModelCopyWith<_NotificationSettingsModel> get copyWith => __$NotificationSettingsModelCopyWithImpl<_NotificationSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.smsEnabled, smsEnabled) || other.smsEnabled == smsEnabled)&&(identical(other.orderConfirmation, orderConfirmation) || other.orderConfirmation == orderConfirmation)&&(identical(other.orderStatus, orderStatus) || other.orderStatus == orderStatus)&&(identical(other.promotions, promotions) || other.promotions == promotions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,pushEnabled,emailEnabled,smsEnabled,orderConfirmation,orderStatus,promotions,createdAt,updatedAt);

@override
String toString() {
  return 'NotificationSettingsModel(id: $id, userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, smsEnabled: $smsEnabled, orderConfirmation: $orderConfirmation, orderStatus: $orderStatus, promotions: $promotions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsModelCopyWith<$Res> implements $NotificationSettingsModelCopyWith<$Res> {
  factory _$NotificationSettingsModelCopyWith(_NotificationSettingsModel value, $Res Function(_NotificationSettingsModel) _then) = __$NotificationSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, bool pushEnabled, bool emailEnabled, bool smsEnabled, bool orderConfirmation, bool orderStatus, bool promotions, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$NotificationSettingsModelCopyWithImpl<$Res>
    implements _$NotificationSettingsModelCopyWith<$Res> {
  __$NotificationSettingsModelCopyWithImpl(this._self, this._then);

  final _NotificationSettingsModel _self;
  final $Res Function(_NotificationSettingsModel) _then;

/// Create a copy of NotificationSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? pushEnabled = null,Object? emailEnabled = null,Object? smsEnabled = null,Object? orderConfirmation = null,Object? orderStatus = null,Object? promotions = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_NotificationSettingsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,smsEnabled: null == smsEnabled ? _self.smsEnabled : smsEnabled // ignore: cast_nullable_to_non_nullable
as bool,orderConfirmation: null == orderConfirmation ? _self.orderConfirmation : orderConfirmation // ignore: cast_nullable_to_non_nullable
as bool,orderStatus: null == orderStatus ? _self.orderStatus : orderStatus // ignore: cast_nullable_to_non_nullable
as bool,promotions: null == promotions ? _self.promotions : promotions // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
