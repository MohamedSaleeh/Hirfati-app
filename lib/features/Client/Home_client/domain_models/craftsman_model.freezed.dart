// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'craftsman_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CraftsmanModel {

/// workers.id
 String get id;/// services.id - the first/default service for this worker
 String? get serviceId;/// workers.category_id (mapped to services/category selection)
 String? get categoryId;/// Joined category data, including available translations.
 CategoryModel? get category;/// profiles.full_name
 String get name;/// profiles.avatar_url
 String? get avatarUrl;/// categories.name  →  profession label shown in UI
 String? get profession;/// workers.rating_average
 double get rating;/// Computed client-side from location delta (not from DB)
 double get distance;/// workers.hourly_rate - السعر بالساعة من قاعدة البيانات
 double get hourlyPrice;/// أقل سعر للخدمات (إذا وجدت)
 double get minServicePrice;/// هل يوجد خدمات محددة لهذا الحرفي؟
 bool get hasServices;/// True when the worker is newly added (no ratings yet)
 bool get isNew;/// profiles.latitude
 double? get latitude;/// profiles.longitude
 double? get longitude;/// profiles.city
 String? get city;
/// Create a copy of CraftsmanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CraftsmanModelCopyWith<CraftsmanModel> get copyWith => _$CraftsmanModelCopyWithImpl<CraftsmanModel>(this as CraftsmanModel, _$identity);

  /// Serializes this CraftsmanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CraftsmanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.category, category) || other.category == category)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.hourlyPrice, hourlyPrice) || other.hourlyPrice == hourlyPrice)&&(identical(other.minServicePrice, minServicePrice) || other.minServicePrice == minServicePrice)&&(identical(other.hasServices, hasServices) || other.hasServices == hasServices)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serviceId,categoryId,category,name,avatarUrl,profession,rating,distance,hourlyPrice,minServicePrice,hasServices,isNew,latitude,longitude,city);

@override
String toString() {
  return 'CraftsmanModel(id: $id, serviceId: $serviceId, categoryId: $categoryId, category: $category, name: $name, avatarUrl: $avatarUrl, profession: $profession, rating: $rating, distance: $distance, hourlyPrice: $hourlyPrice, minServicePrice: $minServicePrice, hasServices: $hasServices, isNew: $isNew, latitude: $latitude, longitude: $longitude, city: $city)';
}


}

/// @nodoc
abstract mixin class $CraftsmanModelCopyWith<$Res>  {
  factory $CraftsmanModelCopyWith(CraftsmanModel value, $Res Function(CraftsmanModel) _then) = _$CraftsmanModelCopyWithImpl;
@useResult
$Res call({
 String id, String? serviceId, String? categoryId, CategoryModel? category, String name, String? avatarUrl, String? profession, double rating, double distance, double hourlyPrice, double minServicePrice, bool hasServices, bool isNew, double? latitude, double? longitude, String? city
});


$CategoryModelCopyWith<$Res>? get category;

}
/// @nodoc
class _$CraftsmanModelCopyWithImpl<$Res>
    implements $CraftsmanModelCopyWith<$Res> {
  _$CraftsmanModelCopyWithImpl(this._self, this._then);

  final CraftsmanModel _self;
  final $Res Function(CraftsmanModel) _then;

/// Create a copy of CraftsmanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serviceId = freezed,Object? categoryId = freezed,Object? category = freezed,Object? name = null,Object? avatarUrl = freezed,Object? profession = freezed,Object? rating = null,Object? distance = null,Object? hourlyPrice = null,Object? minServicePrice = null,Object? hasServices = null,Object? isNew = null,Object? latitude = freezed,Object? longitude = freezed,Object? city = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceId: freezed == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,hourlyPrice: null == hourlyPrice ? _self.hourlyPrice : hourlyPrice // ignore: cast_nullable_to_non_nullable
as double,minServicePrice: null == minServicePrice ? _self.minServicePrice : minServicePrice // ignore: cast_nullable_to_non_nullable
as double,hasServices: null == hasServices ? _self.hasServices : hasServices // ignore: cast_nullable_to_non_nullable
as bool,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CraftsmanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [CraftsmanModel].
extension CraftsmanModelPatterns on CraftsmanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CraftsmanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CraftsmanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CraftsmanModel value)  $default,){
final _that = this;
switch (_that) {
case _CraftsmanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CraftsmanModel value)?  $default,){
final _that = this;
switch (_that) {
case _CraftsmanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? serviceId,  String? categoryId,  CategoryModel? category,  String name,  String? avatarUrl,  String? profession,  double rating,  double distance,  double hourlyPrice,  double minServicePrice,  bool hasServices,  bool isNew,  double? latitude,  double? longitude,  String? city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CraftsmanModel() when $default != null:
return $default(_that.id,_that.serviceId,_that.categoryId,_that.category,_that.name,_that.avatarUrl,_that.profession,_that.rating,_that.distance,_that.hourlyPrice,_that.minServicePrice,_that.hasServices,_that.isNew,_that.latitude,_that.longitude,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? serviceId,  String? categoryId,  CategoryModel? category,  String name,  String? avatarUrl,  String? profession,  double rating,  double distance,  double hourlyPrice,  double minServicePrice,  bool hasServices,  bool isNew,  double? latitude,  double? longitude,  String? city)  $default,) {final _that = this;
switch (_that) {
case _CraftsmanModel():
return $default(_that.id,_that.serviceId,_that.categoryId,_that.category,_that.name,_that.avatarUrl,_that.profession,_that.rating,_that.distance,_that.hourlyPrice,_that.minServicePrice,_that.hasServices,_that.isNew,_that.latitude,_that.longitude,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? serviceId,  String? categoryId,  CategoryModel? category,  String name,  String? avatarUrl,  String? profession,  double rating,  double distance,  double hourlyPrice,  double minServicePrice,  bool hasServices,  bool isNew,  double? latitude,  double? longitude,  String? city)?  $default,) {final _that = this;
switch (_that) {
case _CraftsmanModel() when $default != null:
return $default(_that.id,_that.serviceId,_that.categoryId,_that.category,_that.name,_that.avatarUrl,_that.profession,_that.rating,_that.distance,_that.hourlyPrice,_that.minServicePrice,_that.hasServices,_that.isNew,_that.latitude,_that.longitude,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CraftsmanModel implements CraftsmanModel {
  const _CraftsmanModel({required this.id, this.serviceId, this.categoryId, this.category, required this.name, this.avatarUrl, this.profession, this.rating = 0.0, this.distance = 0.0, this.hourlyPrice = 0.0, this.minServicePrice = 0.0, this.hasServices = false, this.isNew = false, this.latitude, this.longitude, this.city});
  factory _CraftsmanModel.fromJson(Map<String, dynamic> json) => _$CraftsmanModelFromJson(json);

/// workers.id
@override final  String id;
/// services.id - the first/default service for this worker
@override final  String? serviceId;
/// workers.category_id (mapped to services/category selection)
@override final  String? categoryId;
/// Joined category data, including available translations.
@override final  CategoryModel? category;
/// profiles.full_name
@override final  String name;
/// profiles.avatar_url
@override final  String? avatarUrl;
/// categories.name  →  profession label shown in UI
@override final  String? profession;
/// workers.rating_average
@override@JsonKey() final  double rating;
/// Computed client-side from location delta (not from DB)
@override@JsonKey() final  double distance;
/// workers.hourly_rate - السعر بالساعة من قاعدة البيانات
@override@JsonKey() final  double hourlyPrice;
/// أقل سعر للخدمات (إذا وجدت)
@override@JsonKey() final  double minServicePrice;
/// هل يوجد خدمات محددة لهذا الحرفي؟
@override@JsonKey() final  bool hasServices;
/// True when the worker is newly added (no ratings yet)
@override@JsonKey() final  bool isNew;
/// profiles.latitude
@override final  double? latitude;
/// profiles.longitude
@override final  double? longitude;
/// profiles.city
@override final  String? city;

/// Create a copy of CraftsmanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CraftsmanModelCopyWith<_CraftsmanModel> get copyWith => __$CraftsmanModelCopyWithImpl<_CraftsmanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CraftsmanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CraftsmanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.category, category) || other.category == category)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.hourlyPrice, hourlyPrice) || other.hourlyPrice == hourlyPrice)&&(identical(other.minServicePrice, minServicePrice) || other.minServicePrice == minServicePrice)&&(identical(other.hasServices, hasServices) || other.hasServices == hasServices)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serviceId,categoryId,category,name,avatarUrl,profession,rating,distance,hourlyPrice,minServicePrice,hasServices,isNew,latitude,longitude,city);

@override
String toString() {
  return 'CraftsmanModel(id: $id, serviceId: $serviceId, categoryId: $categoryId, category: $category, name: $name, avatarUrl: $avatarUrl, profession: $profession, rating: $rating, distance: $distance, hourlyPrice: $hourlyPrice, minServicePrice: $minServicePrice, hasServices: $hasServices, isNew: $isNew, latitude: $latitude, longitude: $longitude, city: $city)';
}


}

/// @nodoc
abstract mixin class _$CraftsmanModelCopyWith<$Res> implements $CraftsmanModelCopyWith<$Res> {
  factory _$CraftsmanModelCopyWith(_CraftsmanModel value, $Res Function(_CraftsmanModel) _then) = __$CraftsmanModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? serviceId, String? categoryId, CategoryModel? category, String name, String? avatarUrl, String? profession, double rating, double distance, double hourlyPrice, double minServicePrice, bool hasServices, bool isNew, double? latitude, double? longitude, String? city
});


@override $CategoryModelCopyWith<$Res>? get category;

}
/// @nodoc
class __$CraftsmanModelCopyWithImpl<$Res>
    implements _$CraftsmanModelCopyWith<$Res> {
  __$CraftsmanModelCopyWithImpl(this._self, this._then);

  final _CraftsmanModel _self;
  final $Res Function(_CraftsmanModel) _then;

/// Create a copy of CraftsmanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serviceId = freezed,Object? categoryId = freezed,Object? category = freezed,Object? name = null,Object? avatarUrl = freezed,Object? profession = freezed,Object? rating = null,Object? distance = null,Object? hourlyPrice = null,Object? minServicePrice = null,Object? hasServices = null,Object? isNew = null,Object? latitude = freezed,Object? longitude = freezed,Object? city = freezed,}) {
  return _then(_CraftsmanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceId: freezed == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,hourlyPrice: null == hourlyPrice ? _self.hourlyPrice : hourlyPrice // ignore: cast_nullable_to_non_nullable
as double,minServicePrice: null == minServicePrice ? _self.minServicePrice : minServicePrice // ignore: cast_nullable_to_non_nullable
as double,hasServices: null == hasServices ? _self.hasServices : hasServices // ignore: cast_nullable_to_non_nullable
as bool,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CraftsmanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
