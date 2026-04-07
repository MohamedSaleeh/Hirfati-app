import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_item_model.freezed.dart';
part 'work_item_model.g.dart';

enum WorkComplexity { standard, high, critical }

@freezed
abstract class WorkItemModel with _$WorkItemModel {
  const factory WorkItemModel({
    required String id,
    required String title,
    required String description,
    required List<String> imageUrls,
    required String category,
    required WorkComplexity complexity,
    required DateTime createdAt,
    int? views,
    double? rating,
  }) = _WorkItemModel;

  factory WorkItemModel.fromJson(Map<String, dynamic> json) =>
      _$WorkItemModelFromJson(json);
}