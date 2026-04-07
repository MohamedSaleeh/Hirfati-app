import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user_model.freezed.dart';
part 'chat_user_model.g.dart';

@freezed
abstract class ChatUserModel with _$ChatUserModel {
  const factory ChatUserModel({
    required String id,
    required String name,
    String? avatarUrl,
    String? role,
  }) = _ChatUserModel;

  factory ChatUserModel.fromJson(Map<String, dynamic> json) =>
      _$ChatUserModelFromJson(json);
}
