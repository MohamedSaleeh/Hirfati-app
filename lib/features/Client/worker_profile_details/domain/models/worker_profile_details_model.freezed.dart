// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfileDetailsModel {

 String get workerId; String get userId; String get fullName; String? get avatarUrl; String? get city; String get categoryName; String? get categoryIcon; int get experienceYears; String get bio; double get priceMin; double get priceMax; double get ratingAverage; int get ratingCount; int get completedJobsCount; bool get approved; bool get profileCompleted; bool get isFavorite;
/// Create a copy of WorkerProfileDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileDetailsModelCopyWith<WorkerProfileDetailsModel> get copyWith => _$WorkerProfileDetailsModelCopyWithImpl<WorkerProfileDetailsModel>(this as WorkerProfileDetailsModel, _$identity);

  /// Serializes this WorkerProfileDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfileDetailsModel&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.completedJobsCount, completedJobsCount) || other.completedJobsCount == completedJobsCount)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workerId,userId,fullName,avatarUrl,city,categoryName,categoryIcon,experienceYears,bio,priceMin,priceMax,ratingAverage,ratingCount,completedJobsCount,approved,profileCompleted,isFavorite);

@override
String toString() {
  return 'WorkerProfileDetailsModel(workerId: $workerId, userId: $userId, fullName: $fullName, avatarUrl: $avatarUrl, city: $city, categoryName: $categoryName, categoryIcon: $categoryIcon, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax, ratingAverage: $ratingAverage, ratingCount: $ratingCount, completedJobsCount: $completedJobsCount, approved: $approved, profileCompleted: $profileCompleted, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileDetailsModelCopyWith<$Res>  {
  factory $WorkerProfileDetailsModelCopyWith(WorkerProfileDetailsModel value, $Res Function(WorkerProfileDetailsModel) _then) = _$WorkerProfileDetailsModelCopyWithImpl;
@useResult
$Res call({
 String workerId, String userId, String fullName, String? avatarUrl, String? city, String categoryName, String? categoryIcon, int experienceYears, String bio, double priceMin, double priceMax, double ratingAverage, int ratingCount, int completedJobsCount, bool approved, bool profileCompleted, bool isFavorite
});




}
/// @nodoc
class _$WorkerProfileDetailsModelCopyWithImpl<$Res>
    implements $WorkerProfileDetailsModelCopyWith<$Res> {
  _$WorkerProfileDetailsModelCopyWithImpl(this._self, this._then);

  final WorkerProfileDetailsModel _self;
  final $Res Function(WorkerProfileDetailsModel) _then;

/// Create a copy of WorkerProfileDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workerId = null,Object? userId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? city = freezed,Object? categoryName = null,Object? categoryIcon = freezed,Object? experienceYears = null,Object? bio = null,Object? priceMin = null,Object? priceMax = null,Object? ratingAverage = null,Object? ratingCount = null,Object? completedJobsCount = null,Object? approved = null,Object? profileCompleted = null,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,priceMin: null == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double,priceMax: null == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,completedJobsCount: null == completedJobsCount ? _self.completedJobsCount : completedJobsCount // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerProfileDetailsModel].
extension WorkerProfileDetailsModelPatterns on WorkerProfileDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfileDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfileDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfileDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfileDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workerId,  String userId,  String fullName,  String? avatarUrl,  String? city,  String categoryName,  String? categoryIcon,  int experienceYears,  String bio,  double priceMin,  double priceMax,  double ratingAverage,  int ratingCount,  int completedJobsCount,  bool approved,  bool profileCompleted,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfileDetailsModel() when $default != null:
return $default(_that.workerId,_that.userId,_that.fullName,_that.avatarUrl,_that.city,_that.categoryName,_that.categoryIcon,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.ratingAverage,_that.ratingCount,_that.completedJobsCount,_that.approved,_that.profileCompleted,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workerId,  String userId,  String fullName,  String? avatarUrl,  String? city,  String categoryName,  String? categoryIcon,  int experienceYears,  String bio,  double priceMin,  double priceMax,  double ratingAverage,  int ratingCount,  int completedJobsCount,  bool approved,  bool profileCompleted,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileDetailsModel():
return $default(_that.workerId,_that.userId,_that.fullName,_that.avatarUrl,_that.city,_that.categoryName,_that.categoryIcon,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.ratingAverage,_that.ratingCount,_that.completedJobsCount,_that.approved,_that.profileCompleted,_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workerId,  String userId,  String fullName,  String? avatarUrl,  String? city,  String categoryName,  String? categoryIcon,  int experienceYears,  String bio,  double priceMin,  double priceMax,  double ratingAverage,  int ratingCount,  int completedJobsCount,  bool approved,  bool profileCompleted,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileDetailsModel() when $default != null:
return $default(_that.workerId,_that.userId,_that.fullName,_that.avatarUrl,_that.city,_that.categoryName,_that.categoryIcon,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.ratingAverage,_that.ratingCount,_that.completedJobsCount,_that.approved,_that.profileCompleted,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfileDetailsModel implements WorkerProfileDetailsModel {
  const _WorkerProfileDetailsModel({required this.workerId, required this.userId, required this.fullName, required this.avatarUrl, required this.city, required this.categoryName, required this.categoryIcon, required this.experienceYears, required this.bio, required this.priceMin, required this.priceMax, required this.ratingAverage, required this.ratingCount, required this.completedJobsCount, required this.approved, required this.profileCompleted, required this.isFavorite});
  factory _WorkerProfileDetailsModel.fromJson(Map<String, dynamic> json) => _$WorkerProfileDetailsModelFromJson(json);

@override final  String workerId;
@override final  String userId;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String? city;
@override final  String categoryName;
@override final  String? categoryIcon;
@override final  int experienceYears;
@override final  String bio;
@override final  double priceMin;
@override final  double priceMax;
@override final  double ratingAverage;
@override final  int ratingCount;
@override final  int completedJobsCount;
@override final  bool approved;
@override final  bool profileCompleted;
@override final  bool isFavorite;

/// Create a copy of WorkerProfileDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileDetailsModelCopyWith<_WorkerProfileDetailsModel> get copyWith => __$WorkerProfileDetailsModelCopyWithImpl<_WorkerProfileDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfileDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfileDetailsModel&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.completedJobsCount, completedJobsCount) || other.completedJobsCount == completedJobsCount)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workerId,userId,fullName,avatarUrl,city,categoryName,categoryIcon,experienceYears,bio,priceMin,priceMax,ratingAverage,ratingCount,completedJobsCount,approved,profileCompleted,isFavorite);

@override
String toString() {
  return 'WorkerProfileDetailsModel(workerId: $workerId, userId: $userId, fullName: $fullName, avatarUrl: $avatarUrl, city: $city, categoryName: $categoryName, categoryIcon: $categoryIcon, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax, ratingAverage: $ratingAverage, ratingCount: $ratingCount, completedJobsCount: $completedJobsCount, approved: $approved, profileCompleted: $profileCompleted, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileDetailsModelCopyWith<$Res> implements $WorkerProfileDetailsModelCopyWith<$Res> {
  factory _$WorkerProfileDetailsModelCopyWith(_WorkerProfileDetailsModel value, $Res Function(_WorkerProfileDetailsModel) _then) = __$WorkerProfileDetailsModelCopyWithImpl;
@override @useResult
$Res call({
 String workerId, String userId, String fullName, String? avatarUrl, String? city, String categoryName, String? categoryIcon, int experienceYears, String bio, double priceMin, double priceMax, double ratingAverage, int ratingCount, int completedJobsCount, bool approved, bool profileCompleted, bool isFavorite
});




}
/// @nodoc
class __$WorkerProfileDetailsModelCopyWithImpl<$Res>
    implements _$WorkerProfileDetailsModelCopyWith<$Res> {
  __$WorkerProfileDetailsModelCopyWithImpl(this._self, this._then);

  final _WorkerProfileDetailsModel _self;
  final $Res Function(_WorkerProfileDetailsModel) _then;

/// Create a copy of WorkerProfileDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workerId = null,Object? userId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? city = freezed,Object? categoryName = null,Object? categoryIcon = freezed,Object? experienceYears = null,Object? bio = null,Object? priceMin = null,Object? priceMax = null,Object? ratingAverage = null,Object? ratingCount = null,Object? completedJobsCount = null,Object? approved = null,Object? profileCompleted = null,Object? isFavorite = null,}) {
  return _then(_WorkerProfileDetailsModel(
workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,priceMin: null == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double,priceMax: null == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,completedJobsCount: null == completedJobsCount ? _self.completedJobsCount : completedJobsCount // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
