// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerServiceModel {

 String get id; String get title; String? get description; double get price; int? get durationMinutes;
/// Create a copy of WorkerServiceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerServiceModelCopyWith<WorkerServiceModel> get copyWith => _$WorkerServiceModelCopyWithImpl<WorkerServiceModel>(this as WorkerServiceModel, _$identity);

  /// Serializes this WorkerServiceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,price,durationMinutes);

@override
String toString() {
  return 'WorkerServiceModel(id: $id, title: $title, description: $description, price: $price, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $WorkerServiceModelCopyWith<$Res>  {
  factory $WorkerServiceModelCopyWith(WorkerServiceModel value, $Res Function(WorkerServiceModel) _then) = _$WorkerServiceModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, double price, int? durationMinutes
});




}
/// @nodoc
class _$WorkerServiceModelCopyWithImpl<$Res>
    implements $WorkerServiceModelCopyWith<$Res> {
  _$WorkerServiceModelCopyWithImpl(this._self, this._then);

  final WorkerServiceModel _self;
  final $Res Function(WorkerServiceModel) _then;

/// Create a copy of WorkerServiceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? price = null,Object? durationMinutes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerServiceModel].
extension WorkerServiceModelPatterns on WorkerServiceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerServiceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerServiceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerServiceModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerServiceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerServiceModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerServiceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  double price,  int? durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerServiceModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  double price,  int? durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _WorkerServiceModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  double price,  int? durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _WorkerServiceModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.price,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerServiceModel implements WorkerServiceModel {
  const _WorkerServiceModel({required this.id, required this.title, this.description, required this.price, this.durationMinutes});
  factory _WorkerServiceModel.fromJson(Map<String, dynamic> json) => _$WorkerServiceModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  double price;
@override final  int? durationMinutes;

/// Create a copy of WorkerServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerServiceModelCopyWith<_WorkerServiceModel> get copyWith => __$WorkerServiceModelCopyWithImpl<_WorkerServiceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerServiceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,price,durationMinutes);

@override
String toString() {
  return 'WorkerServiceModel(id: $id, title: $title, description: $description, price: $price, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$WorkerServiceModelCopyWith<$Res> implements $WorkerServiceModelCopyWith<$Res> {
  factory _$WorkerServiceModelCopyWith(_WorkerServiceModel value, $Res Function(_WorkerServiceModel) _then) = __$WorkerServiceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, double price, int? durationMinutes
});




}
/// @nodoc
class __$WorkerServiceModelCopyWithImpl<$Res>
    implements _$WorkerServiceModelCopyWith<$Res> {
  __$WorkerServiceModelCopyWithImpl(this._self, this._then);

  final _WorkerServiceModel _self;
  final $Res Function(_WorkerServiceModel) _then;

/// Create a copy of WorkerServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? price = null,Object? durationMinutes = freezed,}) {
  return _then(_WorkerServiceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
