// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileDataModel {

 String get id;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'city') String? get city;@JsonKey(name: 'latitude') double? get latitude;@JsonKey(name: 'longitude') double? get longitude;@JsonKey(name: 'is_profile_completed') bool get isProfileCompleted;@JsonKey(name: 'has_completed_onboarding') bool get hasCompletedOnboarding;
/// Create a copy of ProfileDataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDataModelCopyWith<ProfileDataModel> get copyWith => _$ProfileDataModelCopyWithImpl<ProfileDataModel>(this as ProfileDataModel, _$identity);

  /// Serializes this ProfileDataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDataModel&&(identical(other.id, id) || other.id == id)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isProfileCompleted, isProfileCompleted) || other.isProfileCompleted == isProfileCompleted)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,avatarUrl,city,latitude,longitude,isProfileCompleted,hasCompletedOnboarding);

@override
String toString() {
  return 'ProfileDataModel(id: $id, avatarUrl: $avatarUrl, city: $city, latitude: $latitude, longitude: $longitude, isProfileCompleted: $isProfileCompleted, hasCompletedOnboarding: $hasCompletedOnboarding)';
}


}

/// @nodoc
abstract mixin class $ProfileDataModelCopyWith<$Res>  {
  factory $ProfileDataModelCopyWith(ProfileDataModel value, $Res Function(ProfileDataModel) _then) = _$ProfileDataModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'city') String? city,@JsonKey(name: 'latitude') double? latitude,@JsonKey(name: 'longitude') double? longitude,@JsonKey(name: 'is_profile_completed') bool isProfileCompleted,@JsonKey(name: 'has_completed_onboarding') bool hasCompletedOnboarding
});




}
/// @nodoc
class _$ProfileDataModelCopyWithImpl<$Res>
    implements $ProfileDataModelCopyWith<$Res> {
  _$ProfileDataModelCopyWithImpl(this._self, this._then);

  final ProfileDataModel _self;
  final $Res Function(ProfileDataModel) _then;

/// Create a copy of ProfileDataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? avatarUrl = freezed,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isProfileCompleted = null,Object? hasCompletedOnboarding = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileDataModel].
extension ProfileDataModelPatterns on ProfileDataModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDataModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDataModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDataModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDataModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDataModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'city')  String? city, @JsonKey(name: 'latitude')  double? latitude, @JsonKey(name: 'longitude')  double? longitude, @JsonKey(name: 'is_profile_completed')  bool isProfileCompleted, @JsonKey(name: 'has_completed_onboarding')  bool hasCompletedOnboarding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDataModel() when $default != null:
return $default(_that.id,_that.avatarUrl,_that.city,_that.latitude,_that.longitude,_that.isProfileCompleted,_that.hasCompletedOnboarding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'city')  String? city, @JsonKey(name: 'latitude')  double? latitude, @JsonKey(name: 'longitude')  double? longitude, @JsonKey(name: 'is_profile_completed')  bool isProfileCompleted, @JsonKey(name: 'has_completed_onboarding')  bool hasCompletedOnboarding)  $default,) {final _that = this;
switch (_that) {
case _ProfileDataModel():
return $default(_that.id,_that.avatarUrl,_that.city,_that.latitude,_that.longitude,_that.isProfileCompleted,_that.hasCompletedOnboarding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'city')  String? city, @JsonKey(name: 'latitude')  double? latitude, @JsonKey(name: 'longitude')  double? longitude, @JsonKey(name: 'is_profile_completed')  bool isProfileCompleted, @JsonKey(name: 'has_completed_onboarding')  bool hasCompletedOnboarding)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDataModel() when $default != null:
return $default(_that.id,_that.avatarUrl,_that.city,_that.latitude,_that.longitude,_that.isProfileCompleted,_that.hasCompletedOnboarding);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileDataModel implements ProfileDataModel {
  const _ProfileDataModel({required this.id, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'city') this.city, @JsonKey(name: 'latitude') this.latitude, @JsonKey(name: 'longitude') this.longitude, @JsonKey(name: 'is_profile_completed') this.isProfileCompleted = false, @JsonKey(name: 'has_completed_onboarding') this.hasCompletedOnboarding = false});
  factory _ProfileDataModel.fromJson(Map<String, dynamic> json) => _$ProfileDataModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'city') final  String? city;
@override@JsonKey(name: 'latitude') final  double? latitude;
@override@JsonKey(name: 'longitude') final  double? longitude;
@override@JsonKey(name: 'is_profile_completed') final  bool isProfileCompleted;
@override@JsonKey(name: 'has_completed_onboarding') final  bool hasCompletedOnboarding;

/// Create a copy of ProfileDataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDataModelCopyWith<_ProfileDataModel> get copyWith => __$ProfileDataModelCopyWithImpl<_ProfileDataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDataModel&&(identical(other.id, id) || other.id == id)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isProfileCompleted, isProfileCompleted) || other.isProfileCompleted == isProfileCompleted)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,avatarUrl,city,latitude,longitude,isProfileCompleted,hasCompletedOnboarding);

@override
String toString() {
  return 'ProfileDataModel(id: $id, avatarUrl: $avatarUrl, city: $city, latitude: $latitude, longitude: $longitude, isProfileCompleted: $isProfileCompleted, hasCompletedOnboarding: $hasCompletedOnboarding)';
}


}

/// @nodoc
abstract mixin class _$ProfileDataModelCopyWith<$Res> implements $ProfileDataModelCopyWith<$Res> {
  factory _$ProfileDataModelCopyWith(_ProfileDataModel value, $Res Function(_ProfileDataModel) _then) = __$ProfileDataModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'city') String? city,@JsonKey(name: 'latitude') double? latitude,@JsonKey(name: 'longitude') double? longitude,@JsonKey(name: 'is_profile_completed') bool isProfileCompleted,@JsonKey(name: 'has_completed_onboarding') bool hasCompletedOnboarding
});




}
/// @nodoc
class __$ProfileDataModelCopyWithImpl<$Res>
    implements _$ProfileDataModelCopyWith<$Res> {
  __$ProfileDataModelCopyWithImpl(this._self, this._then);

  final _ProfileDataModel _self;
  final $Res Function(_ProfileDataModel) _then;

/// Create a copy of ProfileDataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? avatarUrl = freezed,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isProfileCompleted = null,Object? hasCompletedOnboarding = null,}) {
  return _then(_ProfileDataModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
