import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_photo_model.dart';

part 'create_order_model.freezed.dart';

@freezed
abstract class CreateOrderModel with _$CreateOrderModel {
  const CreateOrderModel._();

  const factory CreateOrderModel({
    String? workerId,
    String? serviceId,
    String? serviceTitle,
    double? servicePrice,
    int? serviceDurationMinutes,
    @Default('') String categoryId,
    @Default('') String categoryName,
    @Default('') String description,
    @Default(<OrderPhotoModel>[]) List<OrderPhotoModel> photos,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? scheduledDate,
    @JsonKey(includeFromJson: false, includeToJson: false)
    TimeOfDay? scheduledTime,
    @Default('morning') String preferredTimeSlot,
    @Default('') String accessInstructions,
    @Default(0) double estimatedPrice,
    @Default(0) double price,
  }) = _CreateOrderModel;

  bool get isValid =>
      (workerId != null && serviceId != null) &&
      categoryId.isNotEmpty &&
      description.trim().length >= 20 &&
      photos.isNotEmpty &&
      address != null &&
      latitude != null &&
      longitude != null &&
      scheduledDate != null &&
      scheduledTime != null;
}
