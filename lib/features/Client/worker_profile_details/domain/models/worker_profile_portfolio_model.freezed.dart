// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_portfolio_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfilePortfolioModel {

 String get id; String get title; String get description; List<String> get imageUrls; String get category; WorkComplexity get complexity; DateTime get createdAt; int get views; double? get rating;
/// Create a copy of WorkerProfilePortfolioModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfilePortfolioModelCopyWith<WorkerProfilePortfolioModel> get copyWith => _$WorkerProfilePortfolioModelCopyWithImpl<WorkerProfilePortfolioModel>(this as WorkerProfilePortfolioModel, _$identity);

  /// Serializes this WorkerProfilePortfolioModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfilePortfolioModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.category, category) || other.category == category)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.views, views) || other.views == views)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(imageUrls),category,complexity,createdAt,views,rating);

@override
String toString() {
  return 'WorkerProfilePortfolioModel(id: $id, title: $title, description: $description, imageUrls: $imageUrls, category: $category, complexity: $complexity, createdAt: $createdAt, views: $views, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $WorkerProfilePortfolioModelCopyWith<$Res>  {
  factory $WorkerProfilePortfolioModelCopyWith(WorkerProfilePortfolioModel value, $Res Function(WorkerProfilePortfolioModel) _then) = _$WorkerProfilePortfolioModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, List<String> imageUrls, String category, WorkComplexity complexity, DateTime createdAt, int views, double? rating
});




}
/// @nodoc
class _$WorkerProfilePortfolioModelCopyWithImpl<$Res>
    implements $WorkerProfilePortfolioModelCopyWith<$Res> {
  _$WorkerProfilePortfolioModelCopyWithImpl(this._self, this._then);

  final WorkerProfilePortfolioModel _self;
  final $Res Function(WorkerProfilePortfolioModel) _then;

/// Create a copy of WorkerProfilePortfolioModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrls = null,Object? category = null,Object? complexity = null,Object? createdAt = null,Object? views = null,Object? rating = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as WorkComplexity,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerProfilePortfolioModel].
extension WorkerProfilePortfolioModelPatterns on WorkerProfilePortfolioModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfilePortfolioModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfilePortfolioModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfilePortfolioModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfilePortfolioModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfilePortfolioModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfilePortfolioModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> imageUrls,  String category,  WorkComplexity complexity,  DateTime createdAt,  int views,  double? rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfilePortfolioModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrls,_that.category,_that.complexity,_that.createdAt,_that.views,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> imageUrls,  String category,  WorkComplexity complexity,  DateTime createdAt,  int views,  double? rating)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfilePortfolioModel():
return $default(_that.id,_that.title,_that.description,_that.imageUrls,_that.category,_that.complexity,_that.createdAt,_that.views,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  List<String> imageUrls,  String category,  WorkComplexity complexity,  DateTime createdAt,  int views,  double? rating)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfilePortfolioModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrls,_that.category,_that.complexity,_that.createdAt,_that.views,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfilePortfolioModel implements WorkerProfilePortfolioModel {
  const _WorkerProfilePortfolioModel({required this.id, required this.title, required this.description, required final  List<String> imageUrls, required this.category, required this.complexity, required this.createdAt, required this.views, this.rating}): _imageUrls = imageUrls;
  factory _WorkerProfilePortfolioModel.fromJson(Map<String, dynamic> json) => _$WorkerProfilePortfolioModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
 final  List<String> _imageUrls;
@override List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  String category;
@override final  WorkComplexity complexity;
@override final  DateTime createdAt;
@override final  int views;
@override final  double? rating;

/// Create a copy of WorkerProfilePortfolioModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfilePortfolioModelCopyWith<_WorkerProfilePortfolioModel> get copyWith => __$WorkerProfilePortfolioModelCopyWithImpl<_WorkerProfilePortfolioModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfilePortfolioModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfilePortfolioModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.category, category) || other.category == category)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.views, views) || other.views == views)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_imageUrls),category,complexity,createdAt,views,rating);

@override
String toString() {
  return 'WorkerProfilePortfolioModel(id: $id, title: $title, description: $description, imageUrls: $imageUrls, category: $category, complexity: $complexity, createdAt: $createdAt, views: $views, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfilePortfolioModelCopyWith<$Res> implements $WorkerProfilePortfolioModelCopyWith<$Res> {
  factory _$WorkerProfilePortfolioModelCopyWith(_WorkerProfilePortfolioModel value, $Res Function(_WorkerProfilePortfolioModel) _then) = __$WorkerProfilePortfolioModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, List<String> imageUrls, String category, WorkComplexity complexity, DateTime createdAt, int views, double? rating
});




}
/// @nodoc
class __$WorkerProfilePortfolioModelCopyWithImpl<$Res>
    implements _$WorkerProfilePortfolioModelCopyWith<$Res> {
  __$WorkerProfilePortfolioModelCopyWithImpl(this._self, this._then);

  final _WorkerProfilePortfolioModel _self;
  final $Res Function(_WorkerProfilePortfolioModel) _then;

/// Create a copy of WorkerProfilePortfolioModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrls = null,Object? category = null,Object? complexity = null,Object? createdAt = null,Object? views = null,Object? rating = freezed,}) {
  return _then(_WorkerProfilePortfolioModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as WorkComplexity,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
