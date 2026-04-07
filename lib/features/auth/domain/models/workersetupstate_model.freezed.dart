// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workersetupstate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerSetupState {

 String get categoryId; int get experienceYears; String get bio; double? get priceMin; double? get priceMax;
/// Create a copy of WorkerSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerSetupStateCopyWith<WorkerSetupState> get copyWith => _$WorkerSetupStateCopyWithImpl<WorkerSetupState>(this as WorkerSetupState, _$identity);

  /// Serializes this WorkerSetupState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerSetupState&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,experienceYears,bio,priceMin,priceMax);

@override
String toString() {
  return 'WorkerSetupState(categoryId: $categoryId, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax)';
}


}

/// @nodoc
abstract mixin class $WorkerSetupStateCopyWith<$Res>  {
  factory $WorkerSetupStateCopyWith(WorkerSetupState value, $Res Function(WorkerSetupState) _then) = _$WorkerSetupStateCopyWithImpl;
@useResult
$Res call({
 String categoryId, int experienceYears, String bio, double? priceMin, double? priceMax
});




}
/// @nodoc
class _$WorkerSetupStateCopyWithImpl<$Res>
    implements $WorkerSetupStateCopyWith<$Res> {
  _$WorkerSetupStateCopyWithImpl(this._self, this._then);

  final WorkerSetupState _self;
  final $Res Function(WorkerSetupState) _then;

/// Create a copy of WorkerSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? experienceYears = null,Object? bio = null,Object? priceMin = freezed,Object? priceMax = freezed,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerSetupState].
extension WorkerSetupStatePatterns on WorkerSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerSetupState value)  $default,){
final _that = this;
switch (_that) {
case _WorkerSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  int experienceYears,  String bio,  double? priceMin,  double? priceMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerSetupState() when $default != null:
return $default(_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  int experienceYears,  String bio,  double? priceMin,  double? priceMax)  $default,) {final _that = this;
switch (_that) {
case _WorkerSetupState():
return $default(_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  int experienceYears,  String bio,  double? priceMin,  double? priceMax)?  $default,) {final _that = this;
switch (_that) {
case _WorkerSetupState() when $default != null:
return $default(_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerSetupState implements WorkerSetupState {
  const _WorkerSetupState({this.categoryId = '', this.experienceYears = 0, this.bio = '', this.priceMin, this.priceMax});
  factory _WorkerSetupState.fromJson(Map<String, dynamic> json) => _$WorkerSetupStateFromJson(json);

@override@JsonKey() final  String categoryId;
@override@JsonKey() final  int experienceYears;
@override@JsonKey() final  String bio;
@override final  double? priceMin;
@override final  double? priceMax;

/// Create a copy of WorkerSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerSetupStateCopyWith<_WorkerSetupState> get copyWith => __$WorkerSetupStateCopyWithImpl<_WorkerSetupState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerSetupStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerSetupState&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,experienceYears,bio,priceMin,priceMax);

@override
String toString() {
  return 'WorkerSetupState(categoryId: $categoryId, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax)';
}


}

/// @nodoc
abstract mixin class _$WorkerSetupStateCopyWith<$Res> implements $WorkerSetupStateCopyWith<$Res> {
  factory _$WorkerSetupStateCopyWith(_WorkerSetupState value, $Res Function(_WorkerSetupState) _then) = __$WorkerSetupStateCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, int experienceYears, String bio, double? priceMin, double? priceMax
});




}
/// @nodoc
class __$WorkerSetupStateCopyWithImpl<$Res>
    implements _$WorkerSetupStateCopyWith<$Res> {
  __$WorkerSetupStateCopyWithImpl(this._self, this._then);

  final _WorkerSetupState _self;
  final $Res Function(_WorkerSetupState) _then;

/// Create a copy of WorkerSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? experienceYears = null,Object? bio = null,Object? priceMin = freezed,Object? priceMax = freezed,}) {
  return _then(_WorkerSetupState(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
