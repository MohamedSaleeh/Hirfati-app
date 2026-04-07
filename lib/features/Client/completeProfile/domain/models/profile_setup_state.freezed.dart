// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileSetupState {

/// Local file path of the image chosen by the user (before upload)
 String? get avatarLocalPath;/// Remote URL returned after uploading to Supabase Storage
 String? get avatarUrl; String get city; double? get latitude; double? get longitude; bool get isLoading; bool get isProfileCompleted; bool get hasCompletedOnboarding; String? get errorMessage;
/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSetupStateCopyWith<ProfileSetupState> get copyWith => _$ProfileSetupStateCopyWithImpl<ProfileSetupState>(this as ProfileSetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSetupState&&(identical(other.avatarLocalPath, avatarLocalPath) || other.avatarLocalPath == avatarLocalPath)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isProfileCompleted, isProfileCompleted) || other.isProfileCompleted == isProfileCompleted)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,avatarLocalPath,avatarUrl,city,latitude,longitude,isLoading,isProfileCompleted,hasCompletedOnboarding,errorMessage);

@override
String toString() {
  return 'ProfileSetupState(avatarLocalPath: $avatarLocalPath, avatarUrl: $avatarUrl, city: $city, latitude: $latitude, longitude: $longitude, isLoading: $isLoading, isProfileCompleted: $isProfileCompleted, hasCompletedOnboarding: $hasCompletedOnboarding, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ProfileSetupStateCopyWith<$Res>  {
  factory $ProfileSetupStateCopyWith(ProfileSetupState value, $Res Function(ProfileSetupState) _then) = _$ProfileSetupStateCopyWithImpl;
@useResult
$Res call({
 String? avatarLocalPath, String? avatarUrl, String city, double? latitude, double? longitude, bool isLoading, bool isProfileCompleted, bool hasCompletedOnboarding, String? errorMessage
});




}
/// @nodoc
class _$ProfileSetupStateCopyWithImpl<$Res>
    implements $ProfileSetupStateCopyWith<$Res> {
  _$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final ProfileSetupState _self;
  final $Res Function(ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? avatarLocalPath = freezed,Object? avatarUrl = freezed,Object? city = null,Object? latitude = freezed,Object? longitude = freezed,Object? isLoading = null,Object? isProfileCompleted = null,Object? hasCompletedOnboarding = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
avatarLocalPath: freezed == avatarLocalPath ? _self.avatarLocalPath : avatarLocalPath // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSetupState].
extension ProfileSetupStatePatterns on ProfileSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSetupState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? avatarLocalPath,  String? avatarUrl,  String city,  double? latitude,  double? longitude,  bool isLoading,  bool isProfileCompleted,  bool hasCompletedOnboarding,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.avatarLocalPath,_that.avatarUrl,_that.city,_that.latitude,_that.longitude,_that.isLoading,_that.isProfileCompleted,_that.hasCompletedOnboarding,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? avatarLocalPath,  String? avatarUrl,  String city,  double? latitude,  double? longitude,  bool isLoading,  bool isProfileCompleted,  bool hasCompletedOnboarding,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState():
return $default(_that.avatarLocalPath,_that.avatarUrl,_that.city,_that.latitude,_that.longitude,_that.isLoading,_that.isProfileCompleted,_that.hasCompletedOnboarding,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? avatarLocalPath,  String? avatarUrl,  String city,  double? latitude,  double? longitude,  bool isLoading,  bool isProfileCompleted,  bool hasCompletedOnboarding,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.avatarLocalPath,_that.avatarUrl,_that.city,_that.latitude,_that.longitude,_that.isLoading,_that.isProfileCompleted,_that.hasCompletedOnboarding,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileSetupState implements ProfileSetupState {
  const _ProfileSetupState({this.avatarLocalPath, this.avatarUrl, this.city = '', this.latitude, this.longitude, this.isLoading = false, this.isProfileCompleted = false, this.hasCompletedOnboarding = false, this.errorMessage});
  

/// Local file path of the image chosen by the user (before upload)
@override final  String? avatarLocalPath;
/// Remote URL returned after uploading to Supabase Storage
@override final  String? avatarUrl;
@override@JsonKey() final  String city;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isProfileCompleted;
@override@JsonKey() final  bool hasCompletedOnboarding;
@override final  String? errorMessage;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSetupStateCopyWith<_ProfileSetupState> get copyWith => __$ProfileSetupStateCopyWithImpl<_ProfileSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSetupState&&(identical(other.avatarLocalPath, avatarLocalPath) || other.avatarLocalPath == avatarLocalPath)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isProfileCompleted, isProfileCompleted) || other.isProfileCompleted == isProfileCompleted)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,avatarLocalPath,avatarUrl,city,latitude,longitude,isLoading,isProfileCompleted,hasCompletedOnboarding,errorMessage);

@override
String toString() {
  return 'ProfileSetupState(avatarLocalPath: $avatarLocalPath, avatarUrl: $avatarUrl, city: $city, latitude: $latitude, longitude: $longitude, isLoading: $isLoading, isProfileCompleted: $isProfileCompleted, hasCompletedOnboarding: $hasCompletedOnboarding, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ProfileSetupStateCopyWith<$Res> implements $ProfileSetupStateCopyWith<$Res> {
  factory _$ProfileSetupStateCopyWith(_ProfileSetupState value, $Res Function(_ProfileSetupState) _then) = __$ProfileSetupStateCopyWithImpl;
@override @useResult
$Res call({
 String? avatarLocalPath, String? avatarUrl, String city, double? latitude, double? longitude, bool isLoading, bool isProfileCompleted, bool hasCompletedOnboarding, String? errorMessage
});




}
/// @nodoc
class __$ProfileSetupStateCopyWithImpl<$Res>
    implements _$ProfileSetupStateCopyWith<$Res> {
  __$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final _ProfileSetupState _self;
  final $Res Function(_ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? avatarLocalPath = freezed,Object? avatarUrl = freezed,Object? city = null,Object? latitude = freezed,Object? longitude = freezed,Object? isLoading = null,Object? isProfileCompleted = null,Object? hasCompletedOnboarding = null,Object? errorMessage = freezed,}) {
  return _then(_ProfileSetupState(
avatarLocalPath: freezed == avatarLocalPath ? _self.avatarLocalPath : avatarLocalPath // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
