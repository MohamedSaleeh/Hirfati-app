// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sham_cash_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShamCashTransactionModel {

 String get id; String? get fromUserId; String? get toUserId; double get amount; TransactionType get type; TransactionStatus get status; String get reference; DateTime get createdAt; String? get fromUserName; String? get toUserName;
/// Create a copy of ShamCashTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShamCashTransactionModelCopyWith<ShamCashTransactionModel> get copyWith => _$ShamCashTransactionModelCopyWithImpl<ShamCashTransactionModel>(this as ShamCashTransactionModel, _$identity);

  /// Serializes this ShamCashTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShamCashTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fromUserName, fromUserName) || other.fromUserName == fromUserName)&&(identical(other.toUserName, toUserName) || other.toUserName == toUserName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,toUserId,amount,type,status,reference,createdAt,fromUserName,toUserName);

@override
String toString() {
  return 'ShamCashTransactionModel(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, amount: $amount, type: $type, status: $status, reference: $reference, createdAt: $createdAt, fromUserName: $fromUserName, toUserName: $toUserName)';
}


}

/// @nodoc
abstract mixin class $ShamCashTransactionModelCopyWith<$Res>  {
  factory $ShamCashTransactionModelCopyWith(ShamCashTransactionModel value, $Res Function(ShamCashTransactionModel) _then) = _$ShamCashTransactionModelCopyWithImpl;
@useResult
$Res call({
 String id, String? fromUserId, String? toUserId, double amount, TransactionType type, TransactionStatus status, String reference, DateTime createdAt, String? fromUserName, String? toUserName
});




}
/// @nodoc
class _$ShamCashTransactionModelCopyWithImpl<$Res>
    implements $ShamCashTransactionModelCopyWith<$Res> {
  _$ShamCashTransactionModelCopyWithImpl(this._self, this._then);

  final ShamCashTransactionModel _self;
  final $Res Function(ShamCashTransactionModel) _then;

/// Create a copy of ShamCashTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromUserId = freezed,Object? toUserId = freezed,Object? amount = null,Object? type = null,Object? status = null,Object? reference = null,Object? createdAt = null,Object? fromUserName = freezed,Object? toUserName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String?,toUserId: freezed == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromUserName: freezed == fromUserName ? _self.fromUserName : fromUserName // ignore: cast_nullable_to_non_nullable
as String?,toUserName: freezed == toUserName ? _self.toUserName : toUserName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShamCashTransactionModel].
extension ShamCashTransactionModelPatterns on ShamCashTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShamCashTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShamCashTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShamCashTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _ShamCashTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShamCashTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShamCashTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? fromUserId,  String? toUserId,  double amount,  TransactionType type,  TransactionStatus status,  String reference,  DateTime createdAt,  String? fromUserName,  String? toUserName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShamCashTransactionModel() when $default != null:
return $default(_that.id,_that.fromUserId,_that.toUserId,_that.amount,_that.type,_that.status,_that.reference,_that.createdAt,_that.fromUserName,_that.toUserName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? fromUserId,  String? toUserId,  double amount,  TransactionType type,  TransactionStatus status,  String reference,  DateTime createdAt,  String? fromUserName,  String? toUserName)  $default,) {final _that = this;
switch (_that) {
case _ShamCashTransactionModel():
return $default(_that.id,_that.fromUserId,_that.toUserId,_that.amount,_that.type,_that.status,_that.reference,_that.createdAt,_that.fromUserName,_that.toUserName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? fromUserId,  String? toUserId,  double amount,  TransactionType type,  TransactionStatus status,  String reference,  DateTime createdAt,  String? fromUserName,  String? toUserName)?  $default,) {final _that = this;
switch (_that) {
case _ShamCashTransactionModel() when $default != null:
return $default(_that.id,_that.fromUserId,_that.toUserId,_that.amount,_that.type,_that.status,_that.reference,_that.createdAt,_that.fromUserName,_that.toUserName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShamCashTransactionModel implements ShamCashTransactionModel {
  const _ShamCashTransactionModel({required this.id, this.fromUserId, this.toUserId, required this.amount, required this.type, required this.status, required this.reference, required this.createdAt, this.fromUserName, this.toUserName});
  factory _ShamCashTransactionModel.fromJson(Map<String, dynamic> json) => _$ShamCashTransactionModelFromJson(json);

@override final  String id;
@override final  String? fromUserId;
@override final  String? toUserId;
@override final  double amount;
@override final  TransactionType type;
@override final  TransactionStatus status;
@override final  String reference;
@override final  DateTime createdAt;
@override final  String? fromUserName;
@override final  String? toUserName;

/// Create a copy of ShamCashTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShamCashTransactionModelCopyWith<_ShamCashTransactionModel> get copyWith => __$ShamCashTransactionModelCopyWithImpl<_ShamCashTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShamCashTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShamCashTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fromUserName, fromUserName) || other.fromUserName == fromUserName)&&(identical(other.toUserName, toUserName) || other.toUserName == toUserName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,toUserId,amount,type,status,reference,createdAt,fromUserName,toUserName);

@override
String toString() {
  return 'ShamCashTransactionModel(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, amount: $amount, type: $type, status: $status, reference: $reference, createdAt: $createdAt, fromUserName: $fromUserName, toUserName: $toUserName)';
}


}

/// @nodoc
abstract mixin class _$ShamCashTransactionModelCopyWith<$Res> implements $ShamCashTransactionModelCopyWith<$Res> {
  factory _$ShamCashTransactionModelCopyWith(_ShamCashTransactionModel value, $Res Function(_ShamCashTransactionModel) _then) = __$ShamCashTransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? fromUserId, String? toUserId, double amount, TransactionType type, TransactionStatus status, String reference, DateTime createdAt, String? fromUserName, String? toUserName
});




}
/// @nodoc
class __$ShamCashTransactionModelCopyWithImpl<$Res>
    implements _$ShamCashTransactionModelCopyWith<$Res> {
  __$ShamCashTransactionModelCopyWithImpl(this._self, this._then);

  final _ShamCashTransactionModel _self;
  final $Res Function(_ShamCashTransactionModel) _then;

/// Create a copy of ShamCashTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromUserId = freezed,Object? toUserId = freezed,Object? amount = null,Object? type = null,Object? status = null,Object? reference = null,Object? createdAt = null,Object? fromUserName = freezed,Object? toUserName = freezed,}) {
  return _then(_ShamCashTransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String?,toUserId: freezed == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromUserName: freezed == fromUserName ? _self.fromUserName : fromUserName // ignore: cast_nullable_to_non_nullable
as String?,toUserName: freezed == toUserName ? _self.toUserName : toUserName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
