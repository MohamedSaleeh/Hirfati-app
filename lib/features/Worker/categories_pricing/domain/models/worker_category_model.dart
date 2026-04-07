import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_category_model.freezed.dart';
part 'worker_category_model.g.dart';

@freezed
abstract class WorkerCategoryModel with _$WorkerCategoryModel {
  const factory WorkerCategoryModel({
    required String id,
    required String name,
    required String? icon,
    double? priceMin,
    double? priceMax,
  }) = _WorkerCategoryModel;

  factory WorkerCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerCategoryModelFromJson(json);
}