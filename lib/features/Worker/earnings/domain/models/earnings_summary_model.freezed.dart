// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earnings_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EarningsSummaryModel {

 double get availableBalance; double get thisWeekEarnings; double get lastWeekEarnings; double get weeklyChangePercent; int get totalOrders; int get completedOrders;
/// Create a copy of EarningsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsSummaryModelCopyWith<EarningsSummaryModel> get copyWith => _$EarningsSummaryModelCopyWithImpl<EarningsSummaryModel>(this as EarningsSummaryModel, _$identity);

  /// Serializes this EarningsSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsSummaryModel&&(identical(other.availableBalance, availableBalance) || other.availableBalance == availableBalance)&&(identical(other.thisWeekEarnings, thisWeekEarnings) || other.thisWeekEarnings == thisWeekEarnings)&&(identical(other.lastWeekEarnings, lastWeekEarnings) || other.lastWeekEarnings == lastWeekEarnings)&&(identical(other.weeklyChangePercent, weeklyChangePercent) || other.weeklyChangePercent == weeklyChangePercent)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.completedOrders, completedOrders) || other.completedOrders == completedOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,availableBalance,thisWeekEarnings,lastWeekEarnings,weeklyChangePercent,totalOrders,completedOrders);

@override
String toString() {
  return 'EarningsSummaryModel(availableBalance: $availableBalance, thisWeekEarnings: $thisWeekEarnings, lastWeekEarnings: $lastWeekEarnings, weeklyChangePercent: $weeklyChangePercent, totalOrders: $totalOrders, completedOrders: $completedOrders)';
}


}

/// @nodoc
abstract mixin class $EarningsSummaryModelCopyWith<$Res>  {
  factory $EarningsSummaryModelCopyWith(EarningsSummaryModel value, $Res Function(EarningsSummaryModel) _then) = _$EarningsSummaryModelCopyWithImpl;
@useResult
$Res call({
 double availableBalance, double thisWeekEarnings, double lastWeekEarnings, double weeklyChangePercent, int totalOrders, int completedOrders
});




}
/// @nodoc
class _$EarningsSummaryModelCopyWithImpl<$Res>
    implements $EarningsSummaryModelCopyWith<$Res> {
  _$EarningsSummaryModelCopyWithImpl(this._self, this._then);

  final EarningsSummaryModel _self;
  final $Res Function(EarningsSummaryModel) _then;

/// Create a copy of EarningsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? availableBalance = null,Object? thisWeekEarnings = null,Object? lastWeekEarnings = null,Object? weeklyChangePercent = null,Object? totalOrders = null,Object? completedOrders = null,}) {
  return _then(_self.copyWith(
availableBalance: null == availableBalance ? _self.availableBalance : availableBalance // ignore: cast_nullable_to_non_nullable
as double,thisWeekEarnings: null == thisWeekEarnings ? _self.thisWeekEarnings : thisWeekEarnings // ignore: cast_nullable_to_non_nullable
as double,lastWeekEarnings: null == lastWeekEarnings ? _self.lastWeekEarnings : lastWeekEarnings // ignore: cast_nullable_to_non_nullable
as double,weeklyChangePercent: null == weeklyChangePercent ? _self.weeklyChangePercent : weeklyChangePercent // ignore: cast_nullable_to_non_nullable
as double,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,completedOrders: null == completedOrders ? _self.completedOrders : completedOrders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningsSummaryModel].
extension EarningsSummaryModelPatterns on EarningsSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _EarningsSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double availableBalance,  double thisWeekEarnings,  double lastWeekEarnings,  double weeklyChangePercent,  int totalOrders,  int completedOrders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningsSummaryModel() when $default != null:
return $default(_that.availableBalance,_that.thisWeekEarnings,_that.lastWeekEarnings,_that.weeklyChangePercent,_that.totalOrders,_that.completedOrders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double availableBalance,  double thisWeekEarnings,  double lastWeekEarnings,  double weeklyChangePercent,  int totalOrders,  int completedOrders)  $default,) {final _that = this;
switch (_that) {
case _EarningsSummaryModel():
return $default(_that.availableBalance,_that.thisWeekEarnings,_that.lastWeekEarnings,_that.weeklyChangePercent,_that.totalOrders,_that.completedOrders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double availableBalance,  double thisWeekEarnings,  double lastWeekEarnings,  double weeklyChangePercent,  int totalOrders,  int completedOrders)?  $default,) {final _that = this;
switch (_that) {
case _EarningsSummaryModel() when $default != null:
return $default(_that.availableBalance,_that.thisWeekEarnings,_that.lastWeekEarnings,_that.weeklyChangePercent,_that.totalOrders,_that.completedOrders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarningsSummaryModel implements EarningsSummaryModel {
  const _EarningsSummaryModel({required this.availableBalance, required this.thisWeekEarnings, required this.lastWeekEarnings, required this.weeklyChangePercent, required this.totalOrders, required this.completedOrders});
  factory _EarningsSummaryModel.fromJson(Map<String, dynamic> json) => _$EarningsSummaryModelFromJson(json);

@override final  double availableBalance;
@override final  double thisWeekEarnings;
@override final  double lastWeekEarnings;
@override final  double weeklyChangePercent;
@override final  int totalOrders;
@override final  int completedOrders;

/// Create a copy of EarningsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsSummaryModelCopyWith<_EarningsSummaryModel> get copyWith => __$EarningsSummaryModelCopyWithImpl<_EarningsSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsSummaryModel&&(identical(other.availableBalance, availableBalance) || other.availableBalance == availableBalance)&&(identical(other.thisWeekEarnings, thisWeekEarnings) || other.thisWeekEarnings == thisWeekEarnings)&&(identical(other.lastWeekEarnings, lastWeekEarnings) || other.lastWeekEarnings == lastWeekEarnings)&&(identical(other.weeklyChangePercent, weeklyChangePercent) || other.weeklyChangePercent == weeklyChangePercent)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.completedOrders, completedOrders) || other.completedOrders == completedOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,availableBalance,thisWeekEarnings,lastWeekEarnings,weeklyChangePercent,totalOrders,completedOrders);

@override
String toString() {
  return 'EarningsSummaryModel(availableBalance: $availableBalance, thisWeekEarnings: $thisWeekEarnings, lastWeekEarnings: $lastWeekEarnings, weeklyChangePercent: $weeklyChangePercent, totalOrders: $totalOrders, completedOrders: $completedOrders)';
}


}

/// @nodoc
abstract mixin class _$EarningsSummaryModelCopyWith<$Res> implements $EarningsSummaryModelCopyWith<$Res> {
  factory _$EarningsSummaryModelCopyWith(_EarningsSummaryModel value, $Res Function(_EarningsSummaryModel) _then) = __$EarningsSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 double availableBalance, double thisWeekEarnings, double lastWeekEarnings, double weeklyChangePercent, int totalOrders, int completedOrders
});




}
/// @nodoc
class __$EarningsSummaryModelCopyWithImpl<$Res>
    implements _$EarningsSummaryModelCopyWith<$Res> {
  __$EarningsSummaryModelCopyWithImpl(this._self, this._then);

  final _EarningsSummaryModel _self;
  final $Res Function(_EarningsSummaryModel) _then;

/// Create a copy of EarningsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? availableBalance = null,Object? thisWeekEarnings = null,Object? lastWeekEarnings = null,Object? weeklyChangePercent = null,Object? totalOrders = null,Object? completedOrders = null,}) {
  return _then(_EarningsSummaryModel(
availableBalance: null == availableBalance ? _self.availableBalance : availableBalance // ignore: cast_nullable_to_non_nullable
as double,thisWeekEarnings: null == thisWeekEarnings ? _self.thisWeekEarnings : thisWeekEarnings // ignore: cast_nullable_to_non_nullable
as double,lastWeekEarnings: null == lastWeekEarnings ? _self.lastWeekEarnings : lastWeekEarnings // ignore: cast_nullable_to_non_nullable
as double,weeklyChangePercent: null == weeklyChangePercent ? _self.weeklyChangePercent : weeklyChangePercent // ignore: cast_nullable_to_non_nullable
as double,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,completedOrders: null == completedOrders ? _self.completedOrders : completedOrders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
