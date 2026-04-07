// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PinModel {

 String get userId; String get pin; bool get isSet; int get attempts; DateTime? get lastAttemptAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of PinModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinModelCopyWith<PinModel> get copyWith => _$PinModelCopyWithImpl<PinModel>(this as PinModel, _$identity);

  /// Serializes this PinModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.isSet, isSet) || other.isSet == isSet)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.lastAttemptAt, lastAttemptAt) || other.lastAttemptAt == lastAttemptAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,pin,isSet,attempts,lastAttemptAt,createdAt,updatedAt);

@override
String toString() {
  return 'PinModel(userId: $userId, pin: $pin, isSet: $isSet, attempts: $attempts, lastAttemptAt: $lastAttemptAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PinModelCopyWith<$Res>  {
  factory $PinModelCopyWith(PinModel value, $Res Function(PinModel) _then) = _$PinModelCopyWithImpl;
@useResult
$Res call({
 String userId, String pin, bool isSet, int attempts, DateTime? lastAttemptAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$PinModelCopyWithImpl<$Res>
    implements $PinModelCopyWith<$Res> {
  _$PinModelCopyWithImpl(this._self, this._then);

  final PinModel _self;
  final $Res Function(PinModel) _then;

/// Create a copy of PinModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? pin = null,Object? isSet = null,Object? attempts = null,Object? lastAttemptAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,isSet: null == isSet ? _self.isSet : isSet // ignore: cast_nullable_to_non_nullable
as bool,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PinModel].
extension PinModelPatterns on PinModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinModel value)  $default,){
final _that = this;
switch (_that) {
case _PinModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinModel value)?  $default,){
final _that = this;
switch (_that) {
case _PinModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String pin,  bool isSet,  int attempts,  DateTime? lastAttemptAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinModel() when $default != null:
return $default(_that.userId,_that.pin,_that.isSet,_that.attempts,_that.lastAttemptAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String pin,  bool isSet,  int attempts,  DateTime? lastAttemptAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PinModel():
return $default(_that.userId,_that.pin,_that.isSet,_that.attempts,_that.lastAttemptAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String pin,  bool isSet,  int attempts,  DateTime? lastAttemptAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PinModel() when $default != null:
return $default(_that.userId,_that.pin,_that.isSet,_that.attempts,_that.lastAttemptAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PinModel implements PinModel {
  const _PinModel({required this.userId, required this.pin, this.isSet = false, this.attempts = 0, this.lastAttemptAt, this.createdAt, this.updatedAt});
  factory _PinModel.fromJson(Map<String, dynamic> json) => _$PinModelFromJson(json);

@override final  String userId;
@override final  String pin;
@override@JsonKey() final  bool isSet;
@override@JsonKey() final  int attempts;
@override final  DateTime? lastAttemptAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of PinModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinModelCopyWith<_PinModel> get copyWith => __$PinModelCopyWithImpl<_PinModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PinModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.isSet, isSet) || other.isSet == isSet)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.lastAttemptAt, lastAttemptAt) || other.lastAttemptAt == lastAttemptAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,pin,isSet,attempts,lastAttemptAt,createdAt,updatedAt);

@override
String toString() {
  return 'PinModel(userId: $userId, pin: $pin, isSet: $isSet, attempts: $attempts, lastAttemptAt: $lastAttemptAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PinModelCopyWith<$Res> implements $PinModelCopyWith<$Res> {
  factory _$PinModelCopyWith(_PinModel value, $Res Function(_PinModel) _then) = __$PinModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, String pin, bool isSet, int attempts, DateTime? lastAttemptAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$PinModelCopyWithImpl<$Res>
    implements _$PinModelCopyWith<$Res> {
  __$PinModelCopyWithImpl(this._self, this._then);

  final _PinModel _self;
  final $Res Function(_PinModel) _then;

/// Create a copy of PinModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? pin = null,Object? isSet = null,Object? attempts = null,Object? lastAttemptAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PinModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,isSet: null == isSet ? _self.isSet : isSet // ignore: cast_nullable_to_non_nullable
as bool,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
