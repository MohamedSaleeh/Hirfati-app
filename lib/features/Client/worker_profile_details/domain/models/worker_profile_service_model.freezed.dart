// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfileServiceModel {

 String get id; String get title; String get description; double get price; int get durationMinutes;
/// Create a copy of WorkerProfileServiceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileServiceModelCopyWith<WorkerProfileServiceModel> get copyWith => _$WorkerProfileServiceModelCopyWithImpl<WorkerProfileServiceModel>(this as WorkerProfileServiceModel, _$identity);

  /// Serializes this WorkerProfileServiceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfileServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,price,durationMinutes);

@override
String toString() {
  return 'WorkerProfileServiceModel(id: $id, title: $title, description: $description, price: $price, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileServiceModelCopyWith<$Res>  {
  factory $WorkerProfileServiceModelCopyWith(WorkerProfileServiceModel value, $Res Function(WorkerProfileServiceModel) _then) = _$WorkerProfileServiceModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, double price, int durationMinutes
});




}
/// @nodoc
class _$WorkerProfileServiceModelCopyWithImpl<$Res>
    implements $WorkerProfileServiceModelCopyWith<$Res> {
  _$WorkerProfileServiceModelCopyWithImpl(this._self, this._then);

  final WorkerProfileServiceModel _self;
  final $Res Function(WorkerProfileServiceModel) _then;

/// Create a copy of WorkerProfileServiceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? price = null,Object? durationMinutes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerProfileServiceModel].
extension WorkerProfileServiceModelPatterns on WorkerProfileServiceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfileServiceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfileServiceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfileServiceModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileServiceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfileServiceModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileServiceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double price,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfileServiceModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.price,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double price,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileServiceModel():
return $default(_that.id,_that.title,_that.description,_that.price,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  double price,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileServiceModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.price,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfileServiceModel implements WorkerProfileServiceModel {
  const _WorkerProfileServiceModel({required this.id, required this.title, required this.description, required this.price, required this.durationMinutes});
  factory _WorkerProfileServiceModel.fromJson(Map<String, dynamic> json) => _$WorkerProfileServiceModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  double price;
@override final  int durationMinutes;

/// Create a copy of WorkerProfileServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileServiceModelCopyWith<_WorkerProfileServiceModel> get copyWith => __$WorkerProfileServiceModelCopyWithImpl<_WorkerProfileServiceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfileServiceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfileServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,price,durationMinutes);

@override
String toString() {
  return 'WorkerProfileServiceModel(id: $id, title: $title, description: $description, price: $price, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileServiceModelCopyWith<$Res> implements $WorkerProfileServiceModelCopyWith<$Res> {
  factory _$WorkerProfileServiceModelCopyWith(_WorkerProfileServiceModel value, $Res Function(_WorkerProfileServiceModel) _then) = __$WorkerProfileServiceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, double price, int durationMinutes
});




}
/// @nodoc
class __$WorkerProfileServiceModelCopyWithImpl<$Res>
    implements _$WorkerProfileServiceModelCopyWith<$Res> {
  __$WorkerProfileServiceModelCopyWithImpl(this._self, this._then);

  final _WorkerProfileServiceModel _self;
  final $Res Function(_WorkerProfileServiceModel) _then;

/// Create a copy of WorkerProfileServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? price = null,Object? durationMinutes = null,}) {
  return _then(_WorkerProfileServiceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
