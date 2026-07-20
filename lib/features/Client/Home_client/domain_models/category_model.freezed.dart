// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryModel {

 String get id; String get name; String? get icon;@JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson) List<CategoryTranslationModel> get translations;
/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<CategoryModel> get copyWith => _$CategoryModelCopyWithImpl<CategoryModel>(this as CategoryModel, _$identity);

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.translations, translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,const DeepCollectionEquality().hash(translations));

@override
String toString() {
  return 'CategoryModel(id: $id, name: $name, icon: $icon, translations: $translations)';
}


}

/// @nodoc
abstract mixin class $CategoryModelCopyWith<$Res>  {
  factory $CategoryModelCopyWith(CategoryModel value, $Res Function(CategoryModel) _then) = _$CategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? icon,@JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson) List<CategoryTranslationModel> translations
});




}
/// @nodoc
class _$CategoryModelCopyWithImpl<$Res>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._self, this._then);

  final CategoryModel _self;
  final $Res Function(CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? translations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<CategoryTranslationModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryModel].
extension CategoryModelPatterns on CategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? icon, @JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson)  List<CategoryTranslationModel> translations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.translations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? icon, @JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson)  List<CategoryTranslationModel> translations)  $default,) {final _that = this;
switch (_that) {
case _CategoryModel():
return $default(_that.id,_that.name,_that.icon,_that.translations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? icon, @JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson)  List<CategoryTranslationModel> translations)?  $default,) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.translations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryModel implements CategoryModel {
  const _CategoryModel({required this.id, required this.name, this.icon, @JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson) final  List<CategoryTranslationModel> translations = const <CategoryTranslationModel>[]}): _translations = translations;
  factory _CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? icon;
 final  List<CategoryTranslationModel> _translations;
@override@JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson) List<CategoryTranslationModel> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}


/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryModelCopyWith<_CategoryModel> get copyWith => __$CategoryModelCopyWithImpl<_CategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._translations, _translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,const DeepCollectionEquality().hash(_translations));

@override
String toString() {
  return 'CategoryModel(id: $id, name: $name, icon: $icon, translations: $translations)';
}


}

/// @nodoc
abstract mixin class _$CategoryModelCopyWith<$Res> implements $CategoryModelCopyWith<$Res> {
  factory _$CategoryModelCopyWith(_CategoryModel value, $Res Function(_CategoryModel) _then) = __$CategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? icon,@JsonKey(name: 'category_translations', fromJson: _categoryTranslationsFromJson) List<CategoryTranslationModel> translations
});




}
/// @nodoc
class __$CategoryModelCopyWithImpl<$Res>
    implements _$CategoryModelCopyWith<$Res> {
  __$CategoryModelCopyWithImpl(this._self, this._then);

  final _CategoryModel _self;
  final $Res Function(_CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = freezed,Object? translations = null,}) {
  return _then(_CategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<CategoryTranslationModel>,
  ));
}


}


/// @nodoc
mixin _$CategoryTranslationModel {

@JsonKey(name: 'category_id') String get categoryId; String get locale; String get name;@JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson) List<String> get searchTerms;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of CategoryTranslationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryTranslationModelCopyWith<CategoryTranslationModel> get copyWith => _$CategoryTranslationModelCopyWithImpl<CategoryTranslationModel>(this as CategoryTranslationModel, _$identity);

  /// Serializes this CategoryTranslationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryTranslationModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.searchTerms, searchTerms)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,locale,name,const DeepCollectionEquality().hash(searchTerms),createdAt,updatedAt);

@override
String toString() {
  return 'CategoryTranslationModel(categoryId: $categoryId, locale: $locale, name: $name, searchTerms: $searchTerms, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CategoryTranslationModelCopyWith<$Res>  {
  factory $CategoryTranslationModelCopyWith(CategoryTranslationModel value, $Res Function(CategoryTranslationModel) _then) = _$CategoryTranslationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') String categoryId, String locale, String name,@JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson) List<String> searchTerms,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$CategoryTranslationModelCopyWithImpl<$Res>
    implements $CategoryTranslationModelCopyWith<$Res> {
  _$CategoryTranslationModelCopyWithImpl(this._self, this._then);

  final CategoryTranslationModel _self;
  final $Res Function(CategoryTranslationModel) _then;

/// Create a copy of CategoryTranslationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? locale = null,Object? name = null,Object? searchTerms = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,searchTerms: null == searchTerms ? _self.searchTerms : searchTerms // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryTranslationModel].
extension CategoryTranslationModelPatterns on CategoryTranslationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryTranslationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryTranslationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryTranslationModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryTranslationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryTranslationModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryTranslationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  String categoryId,  String locale,  String name, @JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson)  List<String> searchTerms, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryTranslationModel() when $default != null:
return $default(_that.categoryId,_that.locale,_that.name,_that.searchTerms,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  String categoryId,  String locale,  String name, @JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson)  List<String> searchTerms, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CategoryTranslationModel():
return $default(_that.categoryId,_that.locale,_that.name,_that.searchTerms,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  String categoryId,  String locale,  String name, @JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson)  List<String> searchTerms, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CategoryTranslationModel() when $default != null:
return $default(_that.categoryId,_that.locale,_that.name,_that.searchTerms,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryTranslationModel implements CategoryTranslationModel {
  const _CategoryTranslationModel({@JsonKey(name: 'category_id') required this.categoryId, required this.locale, required this.name, @JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson) final  List<String> searchTerms = const <String>[], @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt}): _searchTerms = searchTerms;
  factory _CategoryTranslationModel.fromJson(Map<String, dynamic> json) => _$CategoryTranslationModelFromJson(json);

@override@JsonKey(name: 'category_id') final  String categoryId;
@override final  String locale;
@override final  String name;
 final  List<String> _searchTerms;
@override@JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson) List<String> get searchTerms {
  if (_searchTerms is EqualUnmodifiableListView) return _searchTerms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTerms);
}

@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of CategoryTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryTranslationModelCopyWith<_CategoryTranslationModel> get copyWith => __$CategoryTranslationModelCopyWithImpl<_CategoryTranslationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryTranslationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryTranslationModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._searchTerms, _searchTerms)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,locale,name,const DeepCollectionEquality().hash(_searchTerms),createdAt,updatedAt);

@override
String toString() {
  return 'CategoryTranslationModel(categoryId: $categoryId, locale: $locale, name: $name, searchTerms: $searchTerms, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryTranslationModelCopyWith<$Res> implements $CategoryTranslationModelCopyWith<$Res> {
  factory _$CategoryTranslationModelCopyWith(_CategoryTranslationModel value, $Res Function(_CategoryTranslationModel) _then) = __$CategoryTranslationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') String categoryId, String locale, String name,@JsonKey(name: 'search_terms', fromJson: _searchTermsFromJson) List<String> searchTerms,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$CategoryTranslationModelCopyWithImpl<$Res>
    implements _$CategoryTranslationModelCopyWith<$Res> {
  __$CategoryTranslationModelCopyWithImpl(this._self, this._then);

  final _CategoryTranslationModel _self;
  final $Res Function(_CategoryTranslationModel) _then;

/// Create a copy of CategoryTranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? locale = null,Object? name = null,Object? searchTerms = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CategoryTranslationModel(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,searchTerms: null == searchTerms ? _self._searchTerms : searchTerms // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
