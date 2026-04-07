// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatUserModel {

 String get id; String get name; String? get avatarUrl; String? get role;
/// Create a copy of ChatUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUserModelCopyWith<ChatUserModel> get copyWith => _$ChatUserModelCopyWithImpl<ChatUserModel>(this as ChatUserModel, _$identity);

  /// Serializes this ChatUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,role);

@override
String toString() {
  return 'ChatUserModel(id: $id, name: $name, avatarUrl: $avatarUrl, role: $role)';
}


}

/// @nodoc
abstract mixin class $ChatUserModelCopyWith<$Res>  {
  factory $ChatUserModelCopyWith(ChatUserModel value, $Res Function(ChatUserModel) _then) = _$ChatUserModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatarUrl, String? role
});




}
/// @nodoc
class _$ChatUserModelCopyWithImpl<$Res>
    implements $ChatUserModelCopyWith<$Res> {
  _$ChatUserModelCopyWithImpl(this._self, this._then);

  final ChatUserModel _self;
  final $Res Function(ChatUserModel) _then;

/// Create a copy of ChatUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? role = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUserModel].
extension ChatUserModelPatterns on ChatUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUserModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUserModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? role)  $default,) {final _that = this;
switch (_that) {
case _ChatUserModel():
return $default(_that.id,_that.name,_that.avatarUrl,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatarUrl,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _ChatUserModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatUserModel implements ChatUserModel {
  const _ChatUserModel({required this.id, required this.name, this.avatarUrl, this.role});
  factory _ChatUserModel.fromJson(Map<String, dynamic> json) => _$ChatUserModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? avatarUrl;
@override final  String? role;

/// Create a copy of ChatUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUserModelCopyWith<_ChatUserModel> get copyWith => __$ChatUserModelCopyWithImpl<_ChatUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,role);

@override
String toString() {
  return 'ChatUserModel(id: $id, name: $name, avatarUrl: $avatarUrl, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ChatUserModelCopyWith<$Res> implements $ChatUserModelCopyWith<$Res> {
  factory _$ChatUserModelCopyWith(_ChatUserModel value, $Res Function(_ChatUserModel) _then) = __$ChatUserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatarUrl, String? role
});




}
/// @nodoc
class __$ChatUserModelCopyWithImpl<$Res>
    implements _$ChatUserModelCopyWith<$Res> {
  __$ChatUserModelCopyWithImpl(this._self, this._then);

  final _ChatUserModel _self;
  final $Res Function(_ChatUserModel) _then;

/// Create a copy of ChatUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? role = freezed,}) {
  return _then(_ChatUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
