// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfileModel {

 String get categoryId; int get experienceYears; String get bio; double get priceMin; double get priceMax; bool get isAvailable; double get latitude; double get longitude; String get shamCashCode;
/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileModelCopyWith<WorkerProfileModel> get copyWith => _$WorkerProfileModelCopyWithImpl<WorkerProfileModel>(this as WorkerProfileModel, _$identity);

  /// Serializes this WorkerProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfileModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.shamCashCode, shamCashCode) || other.shamCashCode == shamCashCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,experienceYears,bio,priceMin,priceMax,isAvailable,latitude,longitude,shamCashCode);

@override
String toString() {
  return 'WorkerProfileModel(categoryId: $categoryId, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax, isAvailable: $isAvailable, latitude: $latitude, longitude: $longitude, shamCashCode: $shamCashCode)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileModelCopyWith<$Res>  {
  factory $WorkerProfileModelCopyWith(WorkerProfileModel value, $Res Function(WorkerProfileModel) _then) = _$WorkerProfileModelCopyWithImpl;
@useResult
$Res call({
 String categoryId, int experienceYears, String bio, double priceMin, double priceMax, bool isAvailable, double latitude, double longitude, String shamCashCode
});




}
/// @nodoc
class _$WorkerProfileModelCopyWithImpl<$Res>
    implements $WorkerProfileModelCopyWith<$Res> {
  _$WorkerProfileModelCopyWithImpl(this._self, this._then);

  final WorkerProfileModel _self;
  final $Res Function(WorkerProfileModel) _then;

/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? experienceYears = null,Object? bio = null,Object? priceMin = null,Object? priceMax = null,Object? isAvailable = null,Object? latitude = null,Object? longitude = null,Object? shamCashCode = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,priceMin: null == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double,priceMax: null == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,shamCashCode: null == shamCashCode ? _self.shamCashCode : shamCashCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerProfileModel].
extension WorkerProfileModelPatterns on WorkerProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  int experienceYears,  String bio,  double priceMin,  double priceMax,  bool isAvailable,  double latitude,  double longitude,  String shamCashCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
return $default(_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.isAvailable,_that.latitude,_that.longitude,_that.shamCashCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  int experienceYears,  String bio,  double priceMin,  double priceMax,  bool isAvailable,  double latitude,  double longitude,  String shamCashCode)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileModel():
return $default(_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.isAvailable,_that.latitude,_that.longitude,_that.shamCashCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  int experienceYears,  String bio,  double priceMin,  double priceMax,  bool isAvailable,  double latitude,  double longitude,  String shamCashCode)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
return $default(_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.isAvailable,_that.latitude,_that.longitude,_that.shamCashCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfileModel implements WorkerProfileModel {
  const _WorkerProfileModel({required this.categoryId, required this.experienceYears, required this.bio, required this.priceMin, required this.priceMax, required this.isAvailable, required this.latitude, required this.longitude, required this.shamCashCode});
  factory _WorkerProfileModel.fromJson(Map<String, dynamic> json) => _$WorkerProfileModelFromJson(json);

@override final  String categoryId;
@override final  int experienceYears;
@override final  String bio;
@override final  double priceMin;
@override final  double priceMax;
@override final  bool isAvailable;
@override final  double latitude;
@override final  double longitude;
@override final  String shamCashCode;

/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileModelCopyWith<_WorkerProfileModel> get copyWith => __$WorkerProfileModelCopyWithImpl<_WorkerProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfileModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.shamCashCode, shamCashCode) || other.shamCashCode == shamCashCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,experienceYears,bio,priceMin,priceMax,isAvailable,latitude,longitude,shamCashCode);

@override
String toString() {
  return 'WorkerProfileModel(categoryId: $categoryId, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax, isAvailable: $isAvailable, latitude: $latitude, longitude: $longitude, shamCashCode: $shamCashCode)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileModelCopyWith<$Res> implements $WorkerProfileModelCopyWith<$Res> {
  factory _$WorkerProfileModelCopyWith(_WorkerProfileModel value, $Res Function(_WorkerProfileModel) _then) = __$WorkerProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, int experienceYears, String bio, double priceMin, double priceMax, bool isAvailable, double latitude, double longitude, String shamCashCode
});




}
/// @nodoc
class __$WorkerProfileModelCopyWithImpl<$Res>
    implements _$WorkerProfileModelCopyWith<$Res> {
  __$WorkerProfileModelCopyWithImpl(this._self, this._then);

  final _WorkerProfileModel _self;
  final $Res Function(_WorkerProfileModel) _then;

/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? experienceYears = null,Object? bio = null,Object? priceMin = null,Object? priceMax = null,Object? isAvailable = null,Object? latitude = null,Object? longitude = null,Object? shamCashCode = null,}) {
  return _then(_WorkerProfileModel(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,priceMin: null == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double,priceMax: null == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,shamCashCode: null == shamCashCode ? _self.shamCashCode : shamCashCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
