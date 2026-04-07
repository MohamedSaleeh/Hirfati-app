// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_photo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderPhotoModel {

 String? get localPath; String? get remoteUrl; bool get isUploaded; bool get isUploading; String? get fileName; int? get fileSize;
/// Create a copy of OrderPhotoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderPhotoModelCopyWith<OrderPhotoModel> get copyWith => _$OrderPhotoModelCopyWithImpl<OrderPhotoModel>(this as OrderPhotoModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderPhotoModel&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.remoteUrl, remoteUrl) || other.remoteUrl == remoteUrl)&&(identical(other.isUploaded, isUploaded) || other.isUploaded == isUploaded)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize));
}


@override
int get hashCode => Object.hash(runtimeType,localPath,remoteUrl,isUploaded,isUploading,fileName,fileSize);

@override
String toString() {
  return 'OrderPhotoModel(localPath: $localPath, remoteUrl: $remoteUrl, isUploaded: $isUploaded, isUploading: $isUploading, fileName: $fileName, fileSize: $fileSize)';
}


}

/// @nodoc
abstract mixin class $OrderPhotoModelCopyWith<$Res>  {
  factory $OrderPhotoModelCopyWith(OrderPhotoModel value, $Res Function(OrderPhotoModel) _then) = _$OrderPhotoModelCopyWithImpl;
@useResult
$Res call({
 String? localPath, String? remoteUrl, bool isUploaded, bool isUploading, String? fileName, int? fileSize
});




}
/// @nodoc
class _$OrderPhotoModelCopyWithImpl<$Res>
    implements $OrderPhotoModelCopyWith<$Res> {
  _$OrderPhotoModelCopyWithImpl(this._self, this._then);

  final OrderPhotoModel _self;
  final $Res Function(OrderPhotoModel) _then;

/// Create a copy of OrderPhotoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localPath = freezed,Object? remoteUrl = freezed,Object? isUploaded = null,Object? isUploading = null,Object? fileName = freezed,Object? fileSize = freezed,}) {
  return _then(_self.copyWith(
localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
as String?,isUploaded: null == isUploaded ? _self.isUploaded : isUploaded // ignore: cast_nullable_to_non_nullable
as bool,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderPhotoModel].
extension OrderPhotoModelPatterns on OrderPhotoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderPhotoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderPhotoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderPhotoModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderPhotoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderPhotoModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderPhotoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? localPath,  String? remoteUrl,  bool isUploaded,  bool isUploading,  String? fileName,  int? fileSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderPhotoModel() when $default != null:
return $default(_that.localPath,_that.remoteUrl,_that.isUploaded,_that.isUploading,_that.fileName,_that.fileSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? localPath,  String? remoteUrl,  bool isUploaded,  bool isUploading,  String? fileName,  int? fileSize)  $default,) {final _that = this;
switch (_that) {
case _OrderPhotoModel():
return $default(_that.localPath,_that.remoteUrl,_that.isUploaded,_that.isUploading,_that.fileName,_that.fileSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? localPath,  String? remoteUrl,  bool isUploaded,  bool isUploading,  String? fileName,  int? fileSize)?  $default,) {final _that = this;
switch (_that) {
case _OrderPhotoModel() when $default != null:
return $default(_that.localPath,_that.remoteUrl,_that.isUploaded,_that.isUploading,_that.fileName,_that.fileSize);case _:
  return null;

}
}

}

/// @nodoc


class _OrderPhotoModel implements OrderPhotoModel {
  const _OrderPhotoModel({this.localPath, this.remoteUrl, this.isUploaded = false, this.isUploading = false, this.fileName, this.fileSize});
  

@override final  String? localPath;
@override final  String? remoteUrl;
@override@JsonKey() final  bool isUploaded;
@override@JsonKey() final  bool isUploading;
@override final  String? fileName;
@override final  int? fileSize;

/// Create a copy of OrderPhotoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderPhotoModelCopyWith<_OrderPhotoModel> get copyWith => __$OrderPhotoModelCopyWithImpl<_OrderPhotoModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderPhotoModel&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.remoteUrl, remoteUrl) || other.remoteUrl == remoteUrl)&&(identical(other.isUploaded, isUploaded) || other.isUploaded == isUploaded)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize));
}


@override
int get hashCode => Object.hash(runtimeType,localPath,remoteUrl,isUploaded,isUploading,fileName,fileSize);

@override
String toString() {
  return 'OrderPhotoModel(localPath: $localPath, remoteUrl: $remoteUrl, isUploaded: $isUploaded, isUploading: $isUploading, fileName: $fileName, fileSize: $fileSize)';
}


}

/// @nodoc
abstract mixin class _$OrderPhotoModelCopyWith<$Res> implements $OrderPhotoModelCopyWith<$Res> {
  factory _$OrderPhotoModelCopyWith(_OrderPhotoModel value, $Res Function(_OrderPhotoModel) _then) = __$OrderPhotoModelCopyWithImpl;
@override @useResult
$Res call({
 String? localPath, String? remoteUrl, bool isUploaded, bool isUploading, String? fileName, int? fileSize
});




}
/// @nodoc
class __$OrderPhotoModelCopyWithImpl<$Res>
    implements _$OrderPhotoModelCopyWith<$Res> {
  __$OrderPhotoModelCopyWithImpl(this._self, this._then);

  final _OrderPhotoModel _self;
  final $Res Function(_OrderPhotoModel) _then;

/// Create a copy of OrderPhotoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localPath = freezed,Object? remoteUrl = freezed,Object? isUploaded = null,Object? isUploading = null,Object? fileName = freezed,Object? fileSize = freezed,}) {
  return _then(_OrderPhotoModel(
localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
as String?,isUploaded: null == isUploaded ? _self.isUploaded : isUploaded // ignore: cast_nullable_to_non_nullable
as bool,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
