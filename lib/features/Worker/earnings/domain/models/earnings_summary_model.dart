import 'package:freezed_annotation/freezed_annotation.dart';

part 'earnings_summary_model.freezed.dart';
part 'earnings_summary_model.g.dart';

@freezed
abstract class EarningsSummaryModel with _$EarningsSummaryModel {
  const factory EarningsSummaryModel({
    required double availableBalance,
    required double thisWeekEarnings,
    required double lastWeekEarnings,
    required double weeklyChangePercent,
    required int totalOrders,
    required int completedOrders,
  }) = _EarningsSummaryModel;

  factory EarningsSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$EarningsSummaryModelFromJson(json);
}