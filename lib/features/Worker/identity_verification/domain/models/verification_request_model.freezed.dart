// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerificationRequestModel {

 String get id; String get userId; String get fullName; int get age; String get email; String? get nationalIdUrl; String? get passportUrl; String? get driversLicenseUrl; String? get selfieUrl; VerificationStatus get status; String? get rejectionReason; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of VerificationRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationRequestModelCopyWith<VerificationRequestModel> get copyWith => _$VerificationRequestModelCopyWithImpl<VerificationRequestModel>(this as VerificationRequestModel, _$identity);

  /// Serializes this VerificationRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.age, age) || other.age == age)&&(identical(other.email, email) || other.email == email)&&(identical(other.nationalIdUrl, nationalIdUrl) || other.nationalIdUrl == nationalIdUrl)&&(identical(other.passportUrl, passportUrl) || other.passportUrl == passportUrl)&&(identical(other.driversLicenseUrl, driversLicenseUrl) || other.driversLicenseUrl == driversLicenseUrl)&&(identical(other.selfieUrl, selfieUrl) || other.selfieUrl == selfieUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,age,email,nationalIdUrl,passportUrl,driversLicenseUrl,selfieUrl,status,rejectionReason,createdAt,updatedAt);

@override
String toString() {
  return 'VerificationRequestModel(id: $id, userId: $userId, fullName: $fullName, age: $age, email: $email, nationalIdUrl: $nationalIdUrl, passportUrl: $passportUrl, driversLicenseUrl: $driversLicenseUrl, selfieUrl: $selfieUrl, status: $status, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VerificationRequestModelCopyWith<$Res>  {
  factory $VerificationRequestModelCopyWith(VerificationRequestModel value, $Res Function(VerificationRequestModel) _then) = _$VerificationRequestModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String fullName, int age, String email, String? nationalIdUrl, String? passportUrl, String? driversLicenseUrl, String? selfieUrl, VerificationStatus status, String? rejectionReason, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$VerificationRequestModelCopyWithImpl<$Res>
    implements $VerificationRequestModelCopyWith<$Res> {
  _$VerificationRequestModelCopyWithImpl(this._self, this._then);

  final VerificationRequestModel _self;
  final $Res Function(VerificationRequestModel) _then;

/// Create a copy of VerificationRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? age = null,Object? email = null,Object? nationalIdUrl = freezed,Object? passportUrl = freezed,Object? driversLicenseUrl = freezed,Object? selfieUrl = freezed,Object? status = null,Object? rejectionReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,nationalIdUrl: freezed == nationalIdUrl ? _self.nationalIdUrl : nationalIdUrl // ignore: cast_nullable_to_non_nullable
as String?,passportUrl: freezed == passportUrl ? _self.passportUrl : passportUrl // ignore: cast_nullable_to_non_nullable
as String?,driversLicenseUrl: freezed == driversLicenseUrl ? _self.driversLicenseUrl : driversLicenseUrl // ignore: cast_nullable_to_non_nullable
as String?,selfieUrl: freezed == selfieUrl ? _self.selfieUrl : selfieUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerificationRequestModel].
extension VerificationRequestModelPatterns on VerificationRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerificationRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerificationRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerificationRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _VerificationRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerificationRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _VerificationRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  int age,  String email,  String? nationalIdUrl,  String? passportUrl,  String? driversLicenseUrl,  String? selfieUrl,  VerificationStatus status,  String? rejectionReason,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerificationRequestModel() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.age,_that.email,_that.nationalIdUrl,_that.passportUrl,_that.driversLicenseUrl,_that.selfieUrl,_that.status,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  int age,  String email,  String? nationalIdUrl,  String? passportUrl,  String? driversLicenseUrl,  String? selfieUrl,  VerificationStatus status,  String? rejectionReason,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _VerificationRequestModel():
return $default(_that.id,_that.userId,_that.fullName,_that.age,_that.email,_that.nationalIdUrl,_that.passportUrl,_that.driversLicenseUrl,_that.selfieUrl,_that.status,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String fullName,  int age,  String email,  String? nationalIdUrl,  String? passportUrl,  String? driversLicenseUrl,  String? selfieUrl,  VerificationStatus status,  String? rejectionReason,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _VerificationRequestModel() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.age,_that.email,_that.nationalIdUrl,_that.passportUrl,_that.driversLicenseUrl,_that.selfieUrl,_that.status,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerificationRequestModel implements VerificationRequestModel {
  const _VerificationRequestModel({required this.id, required this.userId, required this.fullName, required this.age, required this.email, this.nationalIdUrl, this.passportUrl, this.driversLicenseUrl, this.selfieUrl, required this.status, this.rejectionReason, this.createdAt, this.updatedAt});
  factory _VerificationRequestModel.fromJson(Map<String, dynamic> json) => _$VerificationRequestModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String fullName;
@override final  int age;
@override final  String email;
@override final  String? nationalIdUrl;
@override final  String? passportUrl;
@override final  String? driversLicenseUrl;
@override final  String? selfieUrl;
@override final  VerificationStatus status;
@override final  String? rejectionReason;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of VerificationRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationRequestModelCopyWith<_VerificationRequestModel> get copyWith => __$VerificationRequestModelCopyWithImpl<_VerificationRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.age, age) || other.age == age)&&(identical(other.email, email) || other.email == email)&&(identical(other.nationalIdUrl, nationalIdUrl) || other.nationalIdUrl == nationalIdUrl)&&(identical(other.passportUrl, passportUrl) || other.passportUrl == passportUrl)&&(identical(other.driversLicenseUrl, driversLicenseUrl) || other.driversLicenseUrl == driversLicenseUrl)&&(identical(other.selfieUrl, selfieUrl) || other.selfieUrl == selfieUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,age,email,nationalIdUrl,passportUrl,driversLicenseUrl,selfieUrl,status,rejectionReason,createdAt,updatedAt);

@override
String toString() {
  return 'VerificationRequestModel(id: $id, userId: $userId, fullName: $fullName, age: $age, email: $email, nationalIdUrl: $nationalIdUrl, passportUrl: $passportUrl, driversLicenseUrl: $driversLicenseUrl, selfieUrl: $selfieUrl, status: $status, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VerificationRequestModelCopyWith<$Res> implements $VerificationRequestModelCopyWith<$Res> {
  factory _$VerificationRequestModelCopyWith(_VerificationRequestModel value, $Res Function(_VerificationRequestModel) _then) = __$VerificationRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String fullName, int age, String email, String? nationalIdUrl, String? passportUrl, String? driversLicenseUrl, String? selfieUrl, VerificationStatus status, String? rejectionReason, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$VerificationRequestModelCopyWithImpl<$Res>
    implements _$VerificationRequestModelCopyWith<$Res> {
  __$VerificationRequestModelCopyWithImpl(this._self, this._then);

  final _VerificationRequestModel _self;
  final $Res Function(_VerificationRequestModel) _then;

/// Create a copy of VerificationRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? age = null,Object? email = null,Object? nationalIdUrl = freezed,Object? passportUrl = freezed,Object? driversLicenseUrl = freezed,Object? selfieUrl = freezed,Object? status = null,Object? rejectionReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_VerificationRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,nationalIdUrl: freezed == nationalIdUrl ? _self.nationalIdUrl : nationalIdUrl // ignore: cast_nullable_to_non_nullable
as String?,passportUrl: freezed == passportUrl ? _self.passportUrl : passportUrl // ignore: cast_nullable_to_non_nullable
as String?,driversLicenseUrl: freezed == driversLicenseUrl ? _self.driversLicenseUrl : driversLicenseUrl // ignore: cast_nullable_to_non_nullable
as String?,selfieUrl: freezed == selfieUrl ? _self.selfieUrl : selfieUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
