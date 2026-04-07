// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkCategoryModel {

 String get id; String get name; String? get icon; bool get isSelected;
/// Create a copy of WorkCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkCategoryModelCopyWith<WorkCategoryModel> get copyWith => _$WorkCategoryModelCopyWithImpl<WorkCategoryModel>(this as WorkCategoryModel, _$identity);

  /// Serializes this WorkCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,isSelected);

@override
String toString() {
  return 'WorkCategoryModel(id: $id, name: $name, icon: $icon, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $WorkCategoryModelCopyWith<$Res>  {
  factory $WorkCategoryModelCopyWith(WorkCategoryModel value, $Res Function(WorkCategoryModel) _then) = _$WorkCategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? icon, bool isSelected
});




}
/// @nodoc
class _$WorkCategoryModelCopyWithImpl<$Res>
    implements $WorkCategoryModelCopyWith<$Res> {
  _$WorkCategoryModelCopyWithImpl(this._self, this._then);

  final WorkCategoryModel _self;
  final $Res Function(WorkCategoryModel) _then;

/// Create a copy of WorkCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? isSelected = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkCategoryModel].
extension WorkCategoryModelPatterns on WorkCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? icon,  bool isSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.isSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? icon,  bool isSelected)  $default,) {final _that = this;
switch (_that) {
case _WorkCategoryModel():
return $default(_that.id,_that.name,_that.icon,_that.isSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? icon,  bool isSelected)?  $default,) {final _that = this;
switch (_that) {
case _WorkCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.isSelected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkCategoryModel implements WorkCategoryModel {
  const _WorkCategoryModel({required this.id, required this.name, this.icon, this.isSelected = false});
  factory _WorkCategoryModel.fromJson(Map<String, dynamic> json) => _$WorkCategoryModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? icon;
@override@JsonKey() final  bool isSelected;

/// Create a copy of WorkCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkCategoryModelCopyWith<_WorkCategoryModel> get copyWith => __$WorkCategoryModelCopyWithImpl<_WorkCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,isSelected);

@override
String toString() {
  return 'WorkCategoryModel(id: $id, name: $name, icon: $icon, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$WorkCategoryModelCopyWith<$Res> implements $WorkCategoryModelCopyWith<$Res> {
  factory _$WorkCategoryModelCopyWith(_WorkCategoryModel value, $Res Function(_WorkCategoryModel) _then) = __$WorkCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? icon, bool isSelected
});




}
/// @nodoc
class __$WorkCategoryModelCopyWithImpl<$Res>
    implements _$WorkCategoryModelCopyWith<$Res> {
  __$WorkCategoryModelCopyWithImpl(this._self, this._then);

  final _WorkCategoryModel _self;
  final $Res Function(_WorkCategoryModel) _then;

/// Create a copy of WorkCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? isSelected = null,}) {
  return _then(_WorkCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
