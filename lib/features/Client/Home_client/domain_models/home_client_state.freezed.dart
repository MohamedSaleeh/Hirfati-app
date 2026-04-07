// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_client_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeClientState {

 bool get isLoading; List<CategoryModel> get categories; List<CraftsmanModel> get recommendedCraftsmen; List<CraftsmanModel> get filteredCraftsmen; String get searchQuery; String? get selectedCategoryId; String? get errorMessage; String? get userCity;
/// Create a copy of HomeClientState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeClientStateCopyWith<HomeClientState> get copyWith => _$HomeClientStateCopyWithImpl<HomeClientState>(this as HomeClientState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeClientState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.recommendedCraftsmen, recommendedCraftsmen)&&const DeepCollectionEquality().equals(other.filteredCraftsmen, filteredCraftsmen)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.userCity, userCity) || other.userCity == userCity));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(recommendedCraftsmen),const DeepCollectionEquality().hash(filteredCraftsmen),searchQuery,selectedCategoryId,errorMessage,userCity);

@override
String toString() {
  return 'HomeClientState(isLoading: $isLoading, categories: $categories, recommendedCraftsmen: $recommendedCraftsmen, filteredCraftsmen: $filteredCraftsmen, searchQuery: $searchQuery, selectedCategoryId: $selectedCategoryId, errorMessage: $errorMessage, userCity: $userCity)';
}


}

/// @nodoc
abstract mixin class $HomeClientStateCopyWith<$Res>  {
  factory $HomeClientStateCopyWith(HomeClientState value, $Res Function(HomeClientState) _then) = _$HomeClientStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<CategoryModel> categories, List<CraftsmanModel> recommendedCraftsmen, List<CraftsmanModel> filteredCraftsmen, String searchQuery, String? selectedCategoryId, String? errorMessage, String? userCity
});




}
/// @nodoc
class _$HomeClientStateCopyWithImpl<$Res>
    implements $HomeClientStateCopyWith<$Res> {
  _$HomeClientStateCopyWithImpl(this._self, this._then);

  final HomeClientState _self;
  final $Res Function(HomeClientState) _then;

/// Create a copy of HomeClientState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? categories = null,Object? recommendedCraftsmen = null,Object? filteredCraftsmen = null,Object? searchQuery = null,Object? selectedCategoryId = freezed,Object? errorMessage = freezed,Object? userCity = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,recommendedCraftsmen: null == recommendedCraftsmen ? _self.recommendedCraftsmen : recommendedCraftsmen // ignore: cast_nullable_to_non_nullable
as List<CraftsmanModel>,filteredCraftsmen: null == filteredCraftsmen ? _self.filteredCraftsmen : filteredCraftsmen // ignore: cast_nullable_to_non_nullable
as List<CraftsmanModel>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,userCity: freezed == userCity ? _self.userCity : userCity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeClientState].
extension HomeClientStatePatterns on HomeClientState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeClientState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeClientState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeClientState value)  $default,){
final _that = this;
switch (_that) {
case _HomeClientState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeClientState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeClientState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<CategoryModel> categories,  List<CraftsmanModel> recommendedCraftsmen,  List<CraftsmanModel> filteredCraftsmen,  String searchQuery,  String? selectedCategoryId,  String? errorMessage,  String? userCity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeClientState() when $default != null:
return $default(_that.isLoading,_that.categories,_that.recommendedCraftsmen,_that.filteredCraftsmen,_that.searchQuery,_that.selectedCategoryId,_that.errorMessage,_that.userCity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<CategoryModel> categories,  List<CraftsmanModel> recommendedCraftsmen,  List<CraftsmanModel> filteredCraftsmen,  String searchQuery,  String? selectedCategoryId,  String? errorMessage,  String? userCity)  $default,) {final _that = this;
switch (_that) {
case _HomeClientState():
return $default(_that.isLoading,_that.categories,_that.recommendedCraftsmen,_that.filteredCraftsmen,_that.searchQuery,_that.selectedCategoryId,_that.errorMessage,_that.userCity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<CategoryModel> categories,  List<CraftsmanModel> recommendedCraftsmen,  List<CraftsmanModel> filteredCraftsmen,  String searchQuery,  String? selectedCategoryId,  String? errorMessage,  String? userCity)?  $default,) {final _that = this;
switch (_that) {
case _HomeClientState() when $default != null:
return $default(_that.isLoading,_that.categories,_that.recommendedCraftsmen,_that.filteredCraftsmen,_that.searchQuery,_that.selectedCategoryId,_that.errorMessage,_that.userCity);case _:
  return null;

}
}

}

/// @nodoc


class _HomeClientState implements HomeClientState {
  const _HomeClientState({this.isLoading = false, final  List<CategoryModel> categories = const [], final  List<CraftsmanModel> recommendedCraftsmen = const [], final  List<CraftsmanModel> filteredCraftsmen = const [], this.searchQuery = '', this.selectedCategoryId, this.errorMessage, this.userCity}): _categories = categories,_recommendedCraftsmen = recommendedCraftsmen,_filteredCraftsmen = filteredCraftsmen;
  

@override@JsonKey() final  bool isLoading;
 final  List<CategoryModel> _categories;
@override@JsonKey() List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<CraftsmanModel> _recommendedCraftsmen;
@override@JsonKey() List<CraftsmanModel> get recommendedCraftsmen {
  if (_recommendedCraftsmen is EqualUnmodifiableListView) return _recommendedCraftsmen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedCraftsmen);
}

 final  List<CraftsmanModel> _filteredCraftsmen;
@override@JsonKey() List<CraftsmanModel> get filteredCraftsmen {
  if (_filteredCraftsmen is EqualUnmodifiableListView) return _filteredCraftsmen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredCraftsmen);
}

@override@JsonKey() final  String searchQuery;
@override final  String? selectedCategoryId;
@override final  String? errorMessage;
@override final  String? userCity;

/// Create a copy of HomeClientState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeClientStateCopyWith<_HomeClientState> get copyWith => __$HomeClientStateCopyWithImpl<_HomeClientState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeClientState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._recommendedCraftsmen, _recommendedCraftsmen)&&const DeepCollectionEquality().equals(other._filteredCraftsmen, _filteredCraftsmen)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.userCity, userCity) || other.userCity == userCity));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_recommendedCraftsmen),const DeepCollectionEquality().hash(_filteredCraftsmen),searchQuery,selectedCategoryId,errorMessage,userCity);

@override
String toString() {
  return 'HomeClientState(isLoading: $isLoading, categories: $categories, recommendedCraftsmen: $recommendedCraftsmen, filteredCraftsmen: $filteredCraftsmen, searchQuery: $searchQuery, selectedCategoryId: $selectedCategoryId, errorMessage: $errorMessage, userCity: $userCity)';
}


}

/// @nodoc
abstract mixin class _$HomeClientStateCopyWith<$Res> implements $HomeClientStateCopyWith<$Res> {
  factory _$HomeClientStateCopyWith(_HomeClientState value, $Res Function(_HomeClientState) _then) = __$HomeClientStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<CategoryModel> categories, List<CraftsmanModel> recommendedCraftsmen, List<CraftsmanModel> filteredCraftsmen, String searchQuery, String? selectedCategoryId, String? errorMessage, String? userCity
});




}
/// @nodoc
class __$HomeClientStateCopyWithImpl<$Res>
    implements _$HomeClientStateCopyWith<$Res> {
  __$HomeClientStateCopyWithImpl(this._self, this._then);

  final _HomeClientState _self;
  final $Res Function(_HomeClientState) _then;

/// Create a copy of HomeClientState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? categories = null,Object? recommendedCraftsmen = null,Object? filteredCraftsmen = null,Object? searchQuery = null,Object? selectedCategoryId = freezed,Object? errorMessage = freezed,Object? userCity = freezed,}) {
  return _then(_HomeClientState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,recommendedCraftsmen: null == recommendedCraftsmen ? _self._recommendedCraftsmen : recommendedCraftsmen // ignore: cast_nullable_to_non_nullable
as List<CraftsmanModel>,filteredCraftsmen: null == filteredCraftsmen ? _self._filteredCraftsmen : filteredCraftsmen // ignore: cast_nullable_to_non_nullable
as List<CraftsmanModel>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,userCity: freezed == userCity ? _self.userCity : userCity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
