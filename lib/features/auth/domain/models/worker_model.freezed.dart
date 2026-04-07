// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'experience_years') int? get experienceYears; String? get bio;@JsonKey(name: 'price_min') double? get priceMin;@JsonKey(name: 'price_max') double? get priceMax;@JsonKey(name: 'rating_average') double get ratingAverage;@JsonKey(name: 'rating_count') int get ratingCount;@JsonKey(name: 'is_available') bool get isAvailable; bool get approved;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerModelCopyWith<WorkerModel> get copyWith => _$WorkerModelCopyWithImpl<WorkerModel>(this as WorkerModel, _$identity);

  /// Serializes this WorkerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,experienceYears,bio,priceMin,priceMax,ratingAverage,ratingCount,isAvailable,approved,createdAt);

@override
String toString() {
  return 'WorkerModel(id: $id, userId: $userId, categoryId: $categoryId, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax, ratingAverage: $ratingAverage, ratingCount: $ratingCount, isAvailable: $isAvailable, approved: $approved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WorkerModelCopyWith<$Res>  {
  factory $WorkerModelCopyWith(WorkerModel value, $Res Function(WorkerModel) _then) = _$WorkerModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'experience_years') int? experienceYears, String? bio,@JsonKey(name: 'price_min') double? priceMin,@JsonKey(name: 'price_max') double? priceMax,@JsonKey(name: 'rating_average') double ratingAverage,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'is_available') bool isAvailable, bool approved,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$WorkerModelCopyWithImpl<$Res>
    implements $WorkerModelCopyWith<$Res> {
  _$WorkerModelCopyWithImpl(this._self, this._then);

  final WorkerModel _self;
  final $Res Function(WorkerModel) _then;

/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? categoryId = freezed,Object? experienceYears = freezed,Object? bio = freezed,Object? priceMin = freezed,Object? priceMax = freezed,Object? ratingAverage = null,Object? ratingCount = null,Object? isAvailable = null,Object? approved = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerModel].
extension WorkerModelPatterns on WorkerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'experience_years')  int? experienceYears,  String? bio, @JsonKey(name: 'price_min')  double? priceMin, @JsonKey(name: 'price_max')  double? priceMax, @JsonKey(name: 'rating_average')  double ratingAverage, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_available')  bool isAvailable,  bool approved, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.ratingAverage,_that.ratingCount,_that.isAvailable,_that.approved,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'experience_years')  int? experienceYears,  String? bio, @JsonKey(name: 'price_min')  double? priceMin, @JsonKey(name: 'price_max')  double? priceMax, @JsonKey(name: 'rating_average')  double ratingAverage, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_available')  bool isAvailable,  bool approved, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _WorkerModel():
return $default(_that.id,_that.userId,_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.ratingAverage,_that.ratingCount,_that.isAvailable,_that.approved,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'experience_years')  int? experienceYears,  String? bio, @JsonKey(name: 'price_min')  double? priceMin, @JsonKey(name: 'price_max')  double? priceMax, @JsonKey(name: 'rating_average')  double ratingAverage, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_available')  bool isAvailable,  bool approved, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.experienceYears,_that.bio,_that.priceMin,_that.priceMax,_that.ratingAverage,_that.ratingCount,_that.isAvailable,_that.approved,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerModel implements WorkerModel {
  const _WorkerModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'experience_years') this.experienceYears, this.bio, @JsonKey(name: 'price_min') this.priceMin, @JsonKey(name: 'price_max') this.priceMax, @JsonKey(name: 'rating_average') this.ratingAverage = 0, @JsonKey(name: 'rating_count') this.ratingCount = 0, @JsonKey(name: 'is_available') this.isAvailable = false, this.approved = false, @JsonKey(name: 'created_at') this.createdAt});
  factory _WorkerModel.fromJson(Map<String, dynamic> json) => _$WorkerModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'experience_years') final  int? experienceYears;
@override final  String? bio;
@override@JsonKey(name: 'price_min') final  double? priceMin;
@override@JsonKey(name: 'price_max') final  double? priceMax;
@override@JsonKey(name: 'rating_average') final  double ratingAverage;
@override@JsonKey(name: 'rating_count') final  int ratingCount;
@override@JsonKey(name: 'is_available') final  bool isAvailable;
@override@JsonKey() final  bool approved;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerModelCopyWith<_WorkerModel> get copyWith => __$WorkerModelCopyWithImpl<_WorkerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,categoryId,experienceYears,bio,priceMin,priceMax,ratingAverage,ratingCount,isAvailable,approved,createdAt);

@override
String toString() {
  return 'WorkerModel(id: $id, userId: $userId, categoryId: $categoryId, experienceYears: $experienceYears, bio: $bio, priceMin: $priceMin, priceMax: $priceMax, ratingAverage: $ratingAverage, ratingCount: $ratingCount, isAvailable: $isAvailable, approved: $approved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WorkerModelCopyWith<$Res> implements $WorkerModelCopyWith<$Res> {
  factory _$WorkerModelCopyWith(_WorkerModel value, $Res Function(_WorkerModel) _then) = __$WorkerModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'experience_years') int? experienceYears, String? bio,@JsonKey(name: 'price_min') double? priceMin,@JsonKey(name: 'price_max') double? priceMax,@JsonKey(name: 'rating_average') double ratingAverage,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'is_available') bool isAvailable, bool approved,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$WorkerModelCopyWithImpl<$Res>
    implements _$WorkerModelCopyWith<$Res> {
  __$WorkerModelCopyWithImpl(this._self, this._then);

  final _WorkerModel _self;
  final $Res Function(_WorkerModel) _then;

/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? categoryId = freezed,Object? experienceYears = freezed,Object? bio = freezed,Object? priceMin = freezed,Object? priceMax = freezed,Object? ratingAverage = null,Object? ratingCount = null,Object? isAvailable = null,Object? approved = null,Object? createdAt = freezed,}) {
  return _then(_WorkerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
