import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_message_model.freezed.dart';
part 'support_message_model.g.dart';

@freezed
abstract class SupportMessageModel with _$SupportMessageModel {
  const factory SupportMessageModel({
    required String id,
    required String userId,
    required String message,
    String? subject,
    @Default(false) bool isResolved,
    DateTime? createdAt,
  }) = _SupportMessageModel;

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SupportMessageModelFromJson(json);
}