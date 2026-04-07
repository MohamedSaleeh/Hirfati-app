import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';

@freezed
abstract class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    required String title,
    String? description,
    required double price,
    int? durationMinutes,
    String? categoryId,
  }) = _ServiceModel;
}