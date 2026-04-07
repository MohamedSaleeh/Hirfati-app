// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sham_cash_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShamCashAccountModel {

 String get id; String get userId; String get accountCode; double get balance; bool get isActive; DateTime get createdAt;
/// Create a copy of ShamCashAccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShamCashAccountModelCopyWith<ShamCashAccountModel> get copyWith => _$ShamCashAccountModelCopyWithImpl<ShamCashAccountModel>(this as ShamCashAccountModel, _$identity);

  /// Serializes this ShamCashAccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShamCashAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,accountCode,balance,isActive,createdAt);

@override
String toString() {
  return 'ShamCashAccountModel(id: $id, userId: $userId, accountCode: $accountCode, balance: $balance, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ShamCashAccountModelCopyWith<$Res>  {
  factory $ShamCashAccountModelCopyWith(ShamCashAccountModel value, $Res Function(ShamCashAccountModel) _then) = _$ShamCashAccountModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String accountCode, double balance, bool isActive, DateTime createdAt
});




}
/// @nodoc
class _$ShamCashAccountModelCopyWithImpl<$Res>
    implements $ShamCashAccountModelCopyWith<$Res> {
  _$ShamCashAccountModelCopyWithImpl(this._self, this._then);

  final ShamCashAccountModel _self;
  final $Res Function(ShamCashAccountModel) _then;

/// Create a copy of ShamCashAccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? accountCode = null,Object? balance = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ShamCashAccountModel].
extension ShamCashAccountModelPatterns on ShamCashAccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShamCashAccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShamCashAccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShamCashAccountModel value)  $default,){
final _that = this;
switch (_that) {
case _ShamCashAccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShamCashAccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShamCashAccountModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String accountCode,  double balance,  bool isActive,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShamCashAccountModel() when $default != null:
return $default(_that.id,_that.userId,_that.accountCode,_that.balance,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String accountCode,  double balance,  bool isActive,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ShamCashAccountModel():
return $default(_that.id,_that.userId,_that.accountCode,_that.balance,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String accountCode,  double balance,  bool isActive,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ShamCashAccountModel() when $default != null:
return $default(_that.id,_that.userId,_that.accountCode,_that.balance,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShamCashAccountModel implements ShamCashAccountModel {
  const _ShamCashAccountModel({required this.id, required this.userId, required this.accountCode, required this.balance, required this.isActive, required this.createdAt});
  factory _ShamCashAccountModel.fromJson(Map<String, dynamic> json) => _$ShamCashAccountModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String accountCode;
@override final  double balance;
@override final  bool isActive;
@override final  DateTime createdAt;

/// Create a copy of ShamCashAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShamCashAccountModelCopyWith<_ShamCashAccountModel> get copyWith => __$ShamCashAccountModelCopyWithImpl<_ShamCashAccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShamCashAccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShamCashAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,accountCode,balance,isActive,createdAt);

@override
String toString() {
  return 'ShamCashAccountModel(id: $id, userId: $userId, accountCode: $accountCode, balance: $balance, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ShamCashAccountModelCopyWith<$Res> implements $ShamCashAccountModelCopyWith<$Res> {
  factory _$ShamCashAccountModelCopyWith(_ShamCashAccountModel value, $Res Function(_ShamCashAccountModel) _then) = __$ShamCashAccountModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String accountCode, double balance, bool isActive, DateTime createdAt
});




}
/// @nodoc
class __$ShamCashAccountModelCopyWithImpl<$Res>
    implements _$ShamCashAccountModelCopyWith<$Res> {
  __$ShamCashAccountModelCopyWithImpl(this._self, this._then);

  final _ShamCashAccountModel _self;
  final $Res Function(_ShamCashAccountModel) _then;

/// Create a copy of ShamCashAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? accountCode = null,Object? balance = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_ShamCashAccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
