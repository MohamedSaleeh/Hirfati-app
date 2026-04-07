import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile_portfolio_model.freezed.dart';
part 'worker_profile_portfolio_model.g.dart';

enum WorkComplexity { standard, high, critical }

@freezed
abstract class WorkerProfilePortfolioModel with _$WorkerProfilePortfolioModel {
  const factory WorkerProfilePortfolioModel({
    required String id,
    required String title,
    required String description,
    required List<String> imageUrls,
    required String category,
    required WorkComplexity complexity,
    required DateTime createdAt,
    required int views,
    double? rating,
  }) = _WorkerProfilePortfolioModel;

  factory WorkerProfilePortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfilePortfolioModelFromJson(json);
}