import '../models/verification_request_model.dart';

abstract class IdentityVerificationRepository {
  Future<VerificationRequestModel?> getVerificationRequest(String userId);
  Future<VerificationRequestModel> submitVerificationRequest({
    required String userId,
    required String fullName,
    required int age,
    required String email,
    String? nationalIdUrl,
    String? passportUrl,
    String? driversLicenseUrl,
    String? selfieUrl,
  });
  Future<String?> uploadDocument(String userId, String documentType, String imagePath);
  Future<String?> getVerificationStatus(String userId);
}