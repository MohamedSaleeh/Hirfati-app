// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkerProfileState {

 bool get isLoading; String? get errorMessage; WorkerProfileDetailsModel? get details; List<WorkerProfilePortfolioModel> get portfolio; List<WorkerProfileServiceModel> get services; List<WorkerProfileReviewModel> get reviews;
/// Create a copy of WorkerProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileStateCopyWith<WorkerProfileState> get copyWith => _$WorkerProfileStateCopyWithImpl<WorkerProfileState>(this as WorkerProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other.portfolio, portfolio)&&const DeepCollectionEquality().equals(other.services, services)&&const DeepCollectionEquality().equals(other.reviews, reviews));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,details,const DeepCollectionEquality().hash(portfolio),const DeepCollectionEquality().hash(services),const DeepCollectionEquality().hash(reviews));

@override
String toString() {
  return 'WorkerProfileState(isLoading: $isLoading, errorMessage: $errorMessage, details: $details, portfolio: $portfolio, services: $services, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileStateCopyWith<$Res>  {
  factory $WorkerProfileStateCopyWith(WorkerProfileState value, $Res Function(WorkerProfileState) _then) = _$WorkerProfileStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorMessage, WorkerProfileDetailsModel? details, List<WorkerProfilePortfolioModel> portfolio, List<WorkerProfileServiceModel> services, List<WorkerProfileReviewModel> reviews
});


$WorkerProfileDetailsModelCopyWith<$Res>? get details;

}
/// @nodoc
class _$WorkerProfileStateCopyWithImpl<$Res>
    implements $WorkerProfileStateCopyWith<$Res> {
  _$WorkerProfileStateCopyWithImpl(this._self, this._then);

  final WorkerProfileState _self;
  final $Res Function(WorkerProfileState) _then;

/// Create a copy of WorkerProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? details = freezed,Object? portfolio = null,Object? services = null,Object? reviews = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as WorkerProfileDetailsModel?,portfolio: null == portfolio ? _self.portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as List<WorkerProfilePortfolioModel>,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<WorkerProfileServiceModel>,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<WorkerProfileReviewModel>,
  ));
}
/// Create a copy of WorkerProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerProfileDetailsModelCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $WorkerProfileDetailsModelCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkerProfileState].
extension WorkerProfileStatePatterns on WorkerProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfileState value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  WorkerProfileDetailsModel? details,  List<WorkerProfilePortfolioModel> portfolio,  List<WorkerProfileServiceModel> services,  List<WorkerProfileReviewModel> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfileState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.details,_that.portfolio,_that.services,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  WorkerProfileDetailsModel? details,  List<WorkerProfilePortfolioModel> portfolio,  List<WorkerProfileServiceModel> services,  List<WorkerProfileReviewModel> reviews)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileState():
return $default(_that.isLoading,_that.errorMessage,_that.details,_that.portfolio,_that.services,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? errorMessage,  WorkerProfileDetailsModel? details,  List<WorkerProfilePortfolioModel> portfolio,  List<WorkerProfileServiceModel> services,  List<WorkerProfileReviewModel> reviews)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfileState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.details,_that.portfolio,_that.services,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc


class _WorkerProfileState implements WorkerProfileState {
  const _WorkerProfileState({this.isLoading = false, this.errorMessage, this.details, final  List<WorkerProfilePortfolioModel> portfolio = const [], final  List<WorkerProfileServiceModel> services = const [], final  List<WorkerProfileReviewModel> reviews = const []}): _portfolio = portfolio,_services = services,_reviews = reviews;
  

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override final  WorkerProfileDetailsModel? details;
 final  List<WorkerProfilePortfolioModel> _portfolio;
@override@JsonKey() List<WorkerProfilePortfolioModel> get portfolio {
  if (_portfolio is EqualUnmodifiableListView) return _portfolio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_portfolio);
}

 final  List<WorkerProfileServiceModel> _services;
@override@JsonKey() List<WorkerProfileServiceModel> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

 final  List<WorkerProfileReviewModel> _reviews;
@override@JsonKey() List<WorkerProfileReviewModel> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of WorkerProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileStateCopyWith<_WorkerProfileState> get copyWith => __$WorkerProfileStateCopyWithImpl<_WorkerProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other._portfolio, _portfolio)&&const DeepCollectionEquality().equals(other._services, _services)&&const DeepCollectionEquality().equals(other._reviews, _reviews));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,details,const DeepCollectionEquality().hash(_portfolio),const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_reviews));

@override
String toString() {
  return 'WorkerProfileState(isLoading: $isLoading, errorMessage: $errorMessage, details: $details, portfolio: $portfolio, services: $services, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileStateCopyWith<$Res> implements $WorkerProfileStateCopyWith<$Res> {
  factory _$WorkerProfileStateCopyWith(_WorkerProfileState value, $Res Function(_WorkerProfileState) _then) = __$WorkerProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorMessage, WorkerProfileDetailsModel? details, List<WorkerProfilePortfolioModel> portfolio, List<WorkerProfileServiceModel> services, List<WorkerProfileReviewModel> reviews
});


@override $WorkerProfileDetailsModelCopyWith<$Res>? get details;

}
/// @nodoc
class __$WorkerProfileStateCopyWithImpl<$Res>
    implements _$WorkerProfileStateCopyWith<$Res> {
  __$WorkerProfileStateCopyWithImpl(this._self, this._then);

  final _WorkerProfileState _self;
  final $Res Function(_WorkerProfileState) _then;

/// Create a copy of WorkerProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? details = freezed,Object? portfolio = null,Object? services = null,Object? reviews = null,}) {
  return _then(_WorkerProfileState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as WorkerProfileDetailsModel?,portfolio: null == portfolio ? _self._portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as List<WorkerProfilePortfolioModel>,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<WorkerProfileServiceModel>,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<WorkerProfileReviewModel>,
  ));
}

/// Create a copy of WorkerProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerProfileDetailsModelCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $WorkerProfileDetailsModelCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

// dart format on
