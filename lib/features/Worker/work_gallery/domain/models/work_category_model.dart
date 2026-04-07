import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_category_model.freezed.dart';
part 'work_category_model.g.dart';

@freezed
abstract class WorkCategoryModel with _$WorkCategoryModel {
  const factory WorkCategoryModel({
    required String id,
    required String name,
    String? icon,
    @Default(false) bool isSelected,
  }) = _WorkCategoryModel;

  factory WorkCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$WorkCategoryModelFromJson(json);
}