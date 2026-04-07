import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_photo_model.freezed.dart';

@freezed
abstract class OrderPhotoModel with _$OrderPhotoModel {
  const factory OrderPhotoModel({
    String? localPath,
    String? remoteUrl,
    @Default(false) bool isUploaded,
    @Default(false) bool isUploading,
    String? fileName,
    int? fileSize,
  }) = _OrderPhotoModel;
}

