import 'package:freezed_annotation/freezed_annotation.dart';

part 'sham_cash_transaction_model.freezed.dart';
part 'sham_cash_transaction_model.g.dart';

enum TransactionType { deposit, payment, transfer, withdraw }

enum TransactionStatus { pending, success, failed }

@freezed
abstract class ShamCashTransactionModel with _$ShamCashTransactionModel {
  const factory ShamCashTransactionModel({
    required String id,
    String? fromUserId,
    String? toUserId,
    required double amount,
    required TransactionType type,
    required TransactionStatus status,
    required String reference,
    required DateTime createdAt,
    String? fromUserName,
    String? toUserName,
  }) = _ShamCashTransactionModel;

  factory ShamCashTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$ShamCashTransactionModelFromJson(json);
}
