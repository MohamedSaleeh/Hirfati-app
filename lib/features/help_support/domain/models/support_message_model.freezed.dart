// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportMessageModel {

 String get id; String get userId; String get message; String? get subject; bool get isResolved; DateTime? get createdAt;
/// Create a copy of SupportMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportMessageModelCopyWith<SupportMessageModel> get copyWith => _$SupportMessageModelCopyWithImpl<SupportMessageModel>(this as SupportMessageModel, _$identity);

  /// Serializes this SupportMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.message, message) || other.message == message)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,message,subject,isResolved,createdAt);

@override
String toString() {
  return 'SupportMessageModel(id: $id, userId: $userId, message: $message, subject: $subject, isResolved: $isResolved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SupportMessageModelCopyWith<$Res>  {
  factory $SupportMessageModelCopyWith(SupportMessageModel value, $Res Function(SupportMessageModel) _then) = _$SupportMessageModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String message, String? subject, bool isResolved, DateTime? createdAt
});




}
/// @nodoc
class _$SupportMessageModelCopyWithImpl<$Res>
    implements $SupportMessageModelCopyWith<$Res> {
  _$SupportMessageModelCopyWithImpl(this._self, this._then);

  final SupportMessageModel _self;
  final $Res Function(SupportMessageModel) _then;

/// Create a copy of SupportMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? message = null,Object? subject = freezed,Object? isResolved = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportMessageModel].
extension SupportMessageModelPatterns on SupportMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _SupportMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _SupportMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String message,  String? subject,  bool isResolved,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportMessageModel() when $default != null:
return $default(_that.id,_that.userId,_that.message,_that.subject,_that.isResolved,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String message,  String? subject,  bool isResolved,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _SupportMessageModel():
return $default(_that.id,_that.userId,_that.message,_that.subject,_that.isResolved,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String message,  String? subject,  bool isResolved,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportMessageModel() when $default != null:
return $default(_that.id,_that.userId,_that.message,_that.subject,_that.isResolved,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportMessageModel implements SupportMessageModel {
  const _SupportMessageModel({required this.id, required this.userId, required this.message, this.subject, this.isResolved = false, this.createdAt});
  factory _SupportMessageModel.fromJson(Map<String, dynamic> json) => _$SupportMessageModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String message;
@override final  String? subject;
@override@JsonKey() final  bool isResolved;
@override final  DateTime? createdAt;

/// Create a copy of SupportMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportMessageModelCopyWith<_SupportMessageModel> get copyWith => __$SupportMessageModelCopyWithImpl<_SupportMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.message, message) || other.message == message)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,message,subject,isResolved,createdAt);

@override
String toString() {
  return 'SupportMessageModel(id: $id, userId: $userId, message: $message, subject: $subject, isResolved: $isResolved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SupportMessageModelCopyWith<$Res> implements $SupportMessageModelCopyWith<$Res> {
  factory _$SupportMessageModelCopyWith(_SupportMessageModel value, $Res Function(_SupportMessageModel) _then) = __$SupportMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String message, String? subject, bool isResolved, DateTime? createdAt
});




}
/// @nodoc
class __$SupportMessageModelCopyWithImpl<$Res>
    implements _$SupportMessageModelCopyWith<$Res> {
  __$SupportMessageModelCopyWithImpl(this._self, this._then);

  final _SupportMessageModel _self;
  final $Res Function(_SupportMessageModel) _then;

/// Create a copy of SupportMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? message = null,Object? subject = freezed,Object? isResolved = null,Object? createdAt = freezed,}) {
  return _then(_SupportMessageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
