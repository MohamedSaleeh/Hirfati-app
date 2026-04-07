import 'package:freezed_annotation/freezed_annotation.dart';

part 'sham_cash_account_model.freezed.dart';
part 'sham_cash_account_model.g.dart';

@freezed
abstract class ShamCashAccountModel with _$ShamCashAccountModel {
  const factory ShamCashAccountModel({
    required String id,
    required String userId,
    required String accountCode,
    required double balance,
    required bool isActive,
    required DateTime createdAt,
  }) = _ShamCashAccountModel;

  factory ShamCashAccountModel.fromJson(Map<String, dynamic> json) =>
      _$ShamCashAccountModelFromJson(json);
}
