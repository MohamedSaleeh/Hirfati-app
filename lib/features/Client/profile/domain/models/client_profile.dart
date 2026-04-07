import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_profile.freezed.dart';
part 'client_profile.g.dart';

@freezed
abstract class ClientProfile with _$ClientProfile {
  const factory ClientProfile({
    required String id,
   @JsonKey(name: 'full_name') String? fullName,
   @JsonKey(name: 'phone') String? phoneNumber,
   @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default('client') String role,
  }) = _ClientProfile;

  factory ClientProfile.fromJson(Map<String, dynamic> json) =>
      _$ClientProfileFromJson(json);
}