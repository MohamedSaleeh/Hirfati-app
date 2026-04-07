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

 String get id; String get userId; String get fullName; String? get avatarUrl; String get role; String? get profession; double get rating; int get reviewCount; int get completedJobs; int get totalHours; bool get isVerified; bool get isAvailable; String? get bio; double get priceMin; double get priceMax;
/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileModelCopyWith<WorkerProfileModel> get copyWith => _$WorkerProfileModelCopyWithImpl<WorkerProfileModel>(this as WorkerProfileModel, _$identity);

  /// Serializes this WorkerProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.completedJobs, completedJobs) || other.completedJobs == completedJobs)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,avatarUrl,role,profession,rating,reviewCount,completedJobs,totalHours,isVerified,isAvailable,bio,priceMin,priceMax);

@override
String toString() {
  return 'WorkerProfileModel(id: $id, userId: $userId, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, profession: $profession, rating: $rating, reviewCount: $reviewCount, completedJobs: $completedJobs, totalHours: $totalHours, isVerified: $isVerified, isAvailable: $isAvailable, bio: $bio, priceMin: $priceMin, priceMax: $priceMax)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileModelCopyWith<$Res>  {
  factory $WorkerProfileModelCopyWith(WorkerProfileModel value, $Res Function(WorkerProfileModel) _then) = _$WorkerProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String fullName, String? avatarUrl, String role, String? profession, double rating, int reviewCount, int completedJobs, int totalHours, bool isVerified, bool isAvailable, String? bio, double priceMin, double priceMax
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = null,Object? profession = freezed,Object? rating = null,Object? reviewCount = null,Object? completedJobs = null,Object? totalHours = null,Object? isVerified = null,Object? isAvailable = null,Object? bio = freezed,Object? priceMin = null,Object? priceMax = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,completedJobs: null == completedJobs ? _self.completedJobs : completedJobs // ignore: cast_nullable_to_non_nullable
as int,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,priceMin: null == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double,priceMax: null == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  String? avatarUrl,  String role,  String? profession,  double rating,  int reviewCount,  int completedJobs,  int totalHours,  bool isVerified,  bool isAvailable,  String? bio,  double priceMin,  double priceMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.avatarUrl,_that.role,_that.profession,_that.rating,_that.reviewCount,_that.completedJobs,_that.totalHours,_that.isVerified,_that.isAvailable,_that.bio,_that.priceMin,_that.priceMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  String? avatarUrl,  String role,  String? profession,  double rating,  int reviewCount,  int completedJobs,  int totalHours,  bool isVerified,  bool isAvailable,  String? bio,  double priceMin,  double priceMax)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileModel():
return $default(_that.id,_that.userId,_that.fullName,_that.avatarUrl,_that.role,_that.profession,_that.rating,_that.reviewCount,_that.completedJobs,_that.totalHours,_that.isVerified,_that.isAvailable,_that.bio,_that.priceMin,_that.priceMax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String fullName,  String? avatarUrl,  String role,  String? profession,  double rating,  int reviewCount,  int completedJobs,  int totalHours,  bool isVerified,  bool isAvailable,  String? bio,  double priceMin,  double priceMax)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.avatarUrl,_that.role,_that.profession,_that.rating,_that.reviewCount,_that.completedJobs,_that.totalHours,_that.isVerified,_that.isAvailable,_that.bio,_that.priceMin,_that.priceMax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfileModel implements WorkerProfileModel {
  const _WorkerProfileModel({required this.id, required this.userId, required this.fullName, this.avatarUrl, this.role = 'worker', this.profession, this.rating = 0.0, this.reviewCount = 0, this.completedJobs = 0, this.totalHours = 0, this.isVerified = false, this.isAvailable = false, this.bio, this.priceMin = 0.0, this.priceMax = 0.0});
  factory _WorkerProfileModel.fromJson(Map<String, dynamic> json) => _$WorkerProfileModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String fullName;
@override final  String? avatarUrl;
@override@JsonKey() final  String role;
@override final  String? profession;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int reviewCount;
@override@JsonKey() final  int completedJobs;
@override@JsonKey() final  int totalHours;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool isAvailable;
@override final  String? bio;
@override@JsonKey() final  double priceMin;
@override@JsonKey() final  double priceMax;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.completedJobs, completedJobs) || other.completedJobs == completedJobs)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,avatarUrl,role,profession,rating,reviewCount,completedJobs,totalHours,isVerified,isAvailable,bio,priceMin,priceMax);

@override
String toString() {
  return 'WorkerProfileModel(id: $id, userId: $userId, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, profession: $profession, rating: $rating, reviewCount: $reviewCount, completedJobs: $completedJobs, totalHours: $totalHours, isVerified: $isVerified, isAvailable: $isAvailable, bio: $bio, priceMin: $priceMin, priceMax: $priceMax)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileModelCopyWith<$Res> implements $WorkerProfileModelCopyWith<$Res> {
  factory _$WorkerProfileModelCopyWith(_WorkerProfileModel value, $Res Function(_WorkerProfileModel) _then) = __$WorkerProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String fullName, String? avatarUrl, String role, String? profession, double rating, int reviewCount, int completedJobs, int totalHours, bool isVerified, bool isAvailable, String? bio, double priceMin, double priceMax
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = null,Object? profession = freezed,Object? rating = null,Object? reviewCount = null,Object? completedJobs = null,Object? totalHours = null,Object? isVerified = null,Object? isAvailable = null,Object? bio = freezed,Object? priceMin = null,Object? priceMax = null,}) {
  return _then(_WorkerProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,completedJobs: null == completedJobs ? _self.completedJobs : completedJobs // ignore: cast_nullable_to_non_nullable
as int,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,priceMin: null == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double,priceMax: null == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
