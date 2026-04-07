// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfileReviewModel {

 String get id; String get clientId; String get clientName; String? get clientAvatarUrl; double get rating; String get comment; DateTime get createdAt;
/// Create a copy of WorkerProfileReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileReviewModelCopyWith<WorkerProfileReviewModel> get copyWith => _$WorkerProfileReviewModelCopyWithImpl<WorkerProfileReviewModel>(this as WorkerProfileReviewModel, _$identity);

  /// Serializes this WorkerProfileReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfileReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientAvatarUrl, clientAvatarUrl) || other.clientAvatarUrl == clientAvatarUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,clientName,clientAvatarUrl,rating,comment,createdAt);

@override
String toString() {
  return 'WorkerProfileReviewModel(id: $id, clientId: $clientId, clientName: $clientName, clientAvatarUrl: $clientAvatarUrl, rating: $rating, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileReviewModelCopyWith<$Res>  {
  factory $WorkerProfileReviewModelCopyWith(WorkerProfileReviewModel value, $Res Function(WorkerProfileReviewModel) _then) = _$WorkerProfileReviewModelCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String clientName, String? clientAvatarUrl, double rating, String comment, DateTime createdAt
});




}
/// @nodoc
class _$WorkerProfileReviewModelCopyWithImpl<$Res>
    implements $WorkerProfileReviewModelCopyWith<$Res> {
  _$WorkerProfileReviewModelCopyWithImpl(this._self, this._then);

  final WorkerProfileReviewModel _self;
  final $Res Function(WorkerProfileReviewModel) _then;

/// Create a copy of WorkerProfileReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? clientName = null,Object? clientAvatarUrl = freezed,Object? rating = null,Object? comment = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientAvatarUrl: freezed == clientAvatarUrl ? _self.clientAvatarUrl : clientAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerProfileReviewModel].
extension WorkerProfileReviewModelPatterns on WorkerProfileReviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfileReviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfileReviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfileReviewModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileReviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfileReviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileReviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientName,  String? clientAvatarUrl,  double rating,  String comment,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfileReviewModel() when $default != null:
return $default(_that.id,_that.clientId,_that.clientName,_that.clientAvatarUrl,_that.rating,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientName,  String? clientAvatarUrl,  double rating,  String comment,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileReviewModel():
return $default(_that.id,_that.clientId,_that.clientName,_that.clientAvatarUrl,_that.rating,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String clientName,  String? clientAvatarUrl,  double rating,  String comment,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileReviewModel() when $default != null:
return $default(_that.id,_that.clientId,_that.clientName,_that.clientAvatarUrl,_that.rating,_that.comment,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfileReviewModel implements WorkerProfileReviewModel {
  const _WorkerProfileReviewModel({required this.id, required this.clientId, required this.clientName, required this.clientAvatarUrl, required this.rating, required this.comment, required this.createdAt});
  factory _WorkerProfileReviewModel.fromJson(Map<String, dynamic> json) => _$WorkerProfileReviewModelFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String clientName;
@override final  String? clientAvatarUrl;
@override final  double rating;
@override final  String comment;
@override final  DateTime createdAt;

/// Create a copy of WorkerProfileReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileReviewModelCopyWith<_WorkerProfileReviewModel> get copyWith => __$WorkerProfileReviewModelCopyWithImpl<_WorkerProfileReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfileReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfileReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientAvatarUrl, clientAvatarUrl) || other.clientAvatarUrl == clientAvatarUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,clientName,clientAvatarUrl,rating,comment,createdAt);

@override
String toString() {
  return 'WorkerProfileReviewModel(id: $id, clientId: $clientId, clientName: $clientName, clientAvatarUrl: $clientAvatarUrl, rating: $rating, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileReviewModelCopyWith<$Res> implements $WorkerProfileReviewModelCopyWith<$Res> {
  factory _$WorkerProfileReviewModelCopyWith(_WorkerProfileReviewModel value, $Res Function(_WorkerProfileReviewModel) _then) = __$WorkerProfileReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String clientName, String? clientAvatarUrl, double rating, String comment, DateTime createdAt
});




}
/// @nodoc
class __$WorkerProfileReviewModelCopyWithImpl<$Res>
    implements _$WorkerProfileReviewModelCopyWith<$Res> {
  __$WorkerProfileReviewModelCopyWithImpl(this._self, this._then);

  final _WorkerProfileReviewModel _self;
  final $Res Function(_WorkerProfileReviewModel) _then;

/// Create a copy of WorkerProfileReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? clientName = null,Object? clientAvatarUrl = freezed,Object? rating = null,Object? comment = null,Object? createdAt = null,}) {
  return _then(_WorkerProfileReviewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientAvatarUrl: freezed == clientAvatarUrl ? _self.clientAvatarUrl : clientAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
