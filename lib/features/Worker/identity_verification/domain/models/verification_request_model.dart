import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_request_model.freezed.dart';
part 'verification_request_model.g.dart';

enum VerificationStatus { pending, approved, rejected }

@freezed
abstract class VerificationRequestModel with _$VerificationRequestModel {
  const factory VerificationRequestModel({
    required String id,
    required String userId,
    required String fullName,
    required int age,
    required String email,
    String? nationalIdUrl,
    String? passportUrl,
    String? driversLicenseUrl,
    String? selfieUrl,
    required VerificationStatus status,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VerificationRequestModel;

  factory VerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestModelFromJson(json);
}