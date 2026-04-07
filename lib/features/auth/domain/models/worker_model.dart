import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_model.freezed.dart';
part 'worker_model.g.dart';

@freezed
abstract class WorkerModel with _$WorkerModel {
  const factory WorkerModel({
    required String id,

    @JsonKey(name: 'user_id')
    required String userId,

    @JsonKey(name: 'category_id')
    String? categoryId,

    @JsonKey(name: 'experience_years')
    int? experienceYears,

    String? bio,

    @JsonKey(name: 'price_min')
    double? priceMin,

    @JsonKey(name: 'price_max')
    double? priceMax,

    @JsonKey(name: 'rating_average')
    @Default(0)
    double ratingAverage,

    @JsonKey(name: 'rating_count')
    @Default(0)
    int ratingCount,

    @JsonKey(name: 'is_available')
    @Default(false)
    bool isAvailable,

    @Default(false)
    bool approved,

    @JsonKey(name: 'created_at')
    DateTime? createdAt,
  }) = _WorkerModel;

  factory WorkerModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerModelFromJson(json);
}
