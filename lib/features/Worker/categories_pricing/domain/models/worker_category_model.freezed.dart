// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerCategoryModel {

 String get id; String get name; String? get icon; double? get priceMin; double? get priceMax;
/// Create a copy of WorkerCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerCategoryModelCopyWith<WorkerCategoryModel> get copyWith => _$WorkerCategoryModelCopyWithImpl<WorkerCategoryModel>(this as WorkerCategoryModel, _$identity);

  /// Serializes this WorkerCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,priceMin,priceMax);

@override
String toString() {
  return 'WorkerCategoryModel(id: $id, name: $name, icon: $icon, priceMin: $priceMin, priceMax: $priceMax)';
}


}

/// @nodoc
abstract mixin class $WorkerCategoryModelCopyWith<$Res>  {
  factory $WorkerCategoryModelCopyWith(WorkerCategoryModel value, $Res Function(WorkerCategoryModel) _then) = _$WorkerCategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? icon, double? priceMin, double? priceMax
});




}
/// @nodoc
class _$WorkerCategoryModelCopyWithImpl<$Res>
    implements $WorkerCategoryModelCopyWith<$Res> {
  _$WorkerCategoryModelCopyWithImpl(this._self, this._then);

  final WorkerCategoryModel _self;
  final $Res Function(WorkerCategoryModel) _then;

/// Create a copy of WorkerCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? priceMin = freezed,Object? priceMax = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerCategoryModel].
extension WorkerCategoryModelPatterns on WorkerCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? icon,  double? priceMin,  double? priceMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.priceMin,_that.priceMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? icon,  double? priceMin,  double? priceMax)  $default,) {final _that = this;
switch (_that) {
case _WorkerCategoryModel():
return $default(_that.id,_that.name,_that.icon,_that.priceMin,_that.priceMax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? icon,  double? priceMin,  double? priceMax)?  $default,) {final _that = this;
switch (_that) {
case _WorkerCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.priceMin,_that.priceMax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerCategoryModel implements WorkerCategoryModel {
  const _WorkerCategoryModel({required this.id, required this.name, required this.icon, this.priceMin, this.priceMax});
  factory _WorkerCategoryModel.fromJson(Map<String, dynamic> json) => _$WorkerCategoryModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? icon;
@override final  double? priceMin;
@override final  double? priceMax;

/// Create a copy of WorkerCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerCategoryModelCopyWith<_WorkerCategoryModel> get copyWith => __$WorkerCategoryModelCopyWithImpl<_WorkerCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,priceMin,priceMax);

@override
String toString() {
  return 'WorkerCategoryModel(id: $id, name: $name, icon: $icon, priceMin: $priceMin, priceMax: $priceMax)';
}


}

/// @nodoc
abstract mixin class _$WorkerCategoryModelCopyWith<$Res> implements $WorkerCategoryModelCopyWith<$Res> {
  factory _$WorkerCategoryModelCopyWith(_WorkerCategoryModel value, $Res Function(_WorkerCategoryModel) _then) = __$WorkerCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? icon, double? priceMin, double? priceMax
});




}
/// @nodoc
class __$WorkerCategoryModelCopyWithImpl<$Res>
    implements _$WorkerCategoryModelCopyWith<$Res> {
  __$WorkerCategoryModelCopyWithImpl(this._self, this._then);

  final _WorkerCategoryModel _self;
  final $Res Function(_WorkerCategoryModel) _then;

/// Create a copy of WorkerCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? priceMin = freezed,Object? priceMax = freezed,}) {
  return _then(_WorkerCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
