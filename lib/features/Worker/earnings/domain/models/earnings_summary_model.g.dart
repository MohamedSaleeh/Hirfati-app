// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EarningsSummaryModel _$EarningsSummaryModelFromJson(
  Map<String, dynamic> json,
) => _EarningsSummaryModel(
  availableBalance: (json['availableBalance'] as num).toDouble(),
  thisWeekEarnings: (json['thisWeekEarnings'] as num).toDouble(),
  lastWeekEarnings: (json['lastWeekEarnings'] as num).toDouble(),
  weeklyChangePercent: (json['weeklyChangePercent'] as num).toDouble(),
  totalOrders: (json['totalOrders'] as num).toInt(),
  completedOrders: (json['completedOrders'] as num).toInt(),
);

Map<String, dynamic> _$EarningsSummaryModelToJson(
  _EarningsSummaryModel instance,
) => <String, dynamic>{
  'availableBalance': instance.availableBalance,
  'thisWeekEarnings': instance.thisWeekEarnings,
  'lastWeekEarnings': instance.lastWeekEarnings,
  'weeklyChangePercent': instance.weeklyChangePercent,
  'totalOrders': instance.totalOrders,
  'completedOrders': instance.completedOrders,
};
