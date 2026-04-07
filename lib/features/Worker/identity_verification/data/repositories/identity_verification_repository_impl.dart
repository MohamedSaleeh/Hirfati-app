import '../../domain/models/verification_request_model.dart';
import '../../domain/repositories/identity_verification_repository.dart';
import '../datasources/identity_verification_supabase_datasource.dart';

class IdentityVerificationRepositoryImpl implements IdentityVerificationRepository {
  final IdentityVerificationSupabaseDatasource _datasource;

  IdentityVerificationRepositoryImpl(this._datasource);

  @override
  Future<VerificationRequestModel?> getVerificationRequest(String userId) async {
    return await _datasource.getVerificationRequest(userId);
  }

  @override
  Future<String?> uploadDocument(String userId, String documentType, String imagePath) async {
    try {
      return await _datasource.uploadDocument(userId, documentType, imagePath);
    } catch (e) {
      print('Error uploading document: $e');
      return null;
    }
  }

  @override
  Future<VerificationRequestModel> submitVerificationRequest({
    required String userId,
    required String fullName,
    required int age,
    required String email,
    String? nationalIdUrl,
    String? passportUrl,
    String? driversLicenseUrl,
    String? selfieUrl,
  }) async {
    return await _datasource.submitVerificationRequest(
      userId: userId,
      fullName: fullName,
      age: age,
      email: email,
      nationalIdUrl: nationalIdUrl,
      passportUrl: passportUrl,
      driversLicenseUrl: driversLicenseUrl,
      selfieUrl: selfieUrl,
    );
  }

  @override
  Future<String?> getVerificationStatus(String userId) async {
    return await _datasource.getVerificationStatus(userId);
  }
}