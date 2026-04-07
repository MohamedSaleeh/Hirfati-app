// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountSettingsModel {

 String get id; String get userId; String get fullName; String? get phone; String? get email; String? get avatarUrl; String? get city; int? get experienceYears; String? get bio;
/// Create a copy of AccountSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSettingsModelCopyWith<AccountSettingsModel> get copyWith => _$AccountSettingsModelCopyWithImpl<AccountSettingsModel>(this as AccountSettingsModel, _$identity);

  /// Serializes this AccountSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,phone,email,avatarUrl,city,experienceYears,bio);

@override
String toString() {
  return 'AccountSettingsModel(id: $id, userId: $userId, fullName: $fullName, phone: $phone, email: $email, avatarUrl: $avatarUrl, city: $city, experienceYears: $experienceYears, bio: $bio)';
}


}

/// @nodoc
abstract mixin class $AccountSettingsModelCopyWith<$Res>  {
  factory $AccountSettingsModelCopyWith(AccountSettingsModel value, $Res Function(AccountSettingsModel) _then) = _$AccountSettingsModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String fullName, String? phone, String? email, String? avatarUrl, String? city, int? experienceYears, String? bio
});




}
/// @nodoc
class _$AccountSettingsModelCopyWithImpl<$Res>
    implements $AccountSettingsModelCopyWith<$Res> {
  _$AccountSettingsModelCopyWithImpl(this._self, this._then);

  final AccountSettingsModel _self;
  final $Res Function(AccountSettingsModel) _then;

/// Create a copy of AccountSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? phone = freezed,Object? email = freezed,Object? avatarUrl = freezed,Object? city = freezed,Object? experienceYears = freezed,Object? bio = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountSettingsModel].
extension AccountSettingsModelPatterns on AccountSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _AccountSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccountSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  String? phone,  String? email,  String? avatarUrl,  String? city,  int? experienceYears,  String? bio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountSettingsModel() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.phone,_that.email,_that.avatarUrl,_that.city,_that.experienceYears,_that.bio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  String? phone,  String? email,  String? avatarUrl,  String? city,  int? experienceYears,  String? bio)  $default,) {final _that = this;
switch (_that) {
case _AccountSettingsModel():
return $default(_that.id,_that.userId,_that.fullName,_that.phone,_that.email,_that.avatarUrl,_that.city,_that.experienceYears,_that.bio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String fullName,  String? phone,  String? email,  String? avatarUrl,  String? city,  int? experienceYears,  String? bio)?  $default,) {final _that = this;
switch (_that) {
case _AccountSettingsModel() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.phone,_that.email,_that.avatarUrl,_that.city,_that.experienceYears,_that.bio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountSettingsModel implements AccountSettingsModel {
  const _AccountSettingsModel({required this.id, required this.userId, required this.fullName, this.phone, this.email, this.avatarUrl, this.city, this.experienceYears, this.bio});
  factory _AccountSettingsModel.fromJson(Map<String, dynamic> json) => _$AccountSettingsModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String fullName;
@override final  String? phone;
@override final  String? email;
@override final  String? avatarUrl;
@override final  String? city;
@override final  int? experienceYears;
@override final  String? bio;

/// Create a copy of AccountSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountSettingsModelCopyWith<_AccountSettingsModel> get copyWith => __$AccountSettingsModelCopyWithImpl<_AccountSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,phone,email,avatarUrl,city,experienceYears,bio);

@override
String toString() {
  return 'AccountSettingsModel(id: $id, userId: $userId, fullName: $fullName, phone: $phone, email: $email, avatarUrl: $avatarUrl, city: $city, experienceYears: $experienceYears, bio: $bio)';
}


}

/// @nodoc
abstract mixin class _$AccountSettingsModelCopyWith<$Res> implements $AccountSettingsModelCopyWith<$Res> {
  factory _$AccountSettingsModelCopyWith(_AccountSettingsModel value, $Res Function(_AccountSettingsModel) _then) = __$AccountSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String fullName, String? phone, String? email, String? avatarUrl, String? city, int? experienceYears, String? bio
});




}
/// @nodoc
class __$AccountSettingsModelCopyWithImpl<$Res>
    implements _$AccountSettingsModelCopyWith<$Res> {
  __$AccountSettingsModelCopyWithImpl(this._self, this._then);

  final _AccountSettingsModel _self;
  final $Res Function(_AccountSettingsModel) _then;

/// Create a copy of AccountSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? phone = freezed,Object? email = freezed,Object? avatarUrl = freezed,Object? city = freezed,Object? experienceYears = freezed,Object? bio = freezed,}) {
  return _then(_AccountSettingsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
