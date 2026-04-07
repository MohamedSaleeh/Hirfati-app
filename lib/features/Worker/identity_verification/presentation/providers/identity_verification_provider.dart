import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/providers/identity_verification_providers.dart';
import '../../domain/models/verification_request_model.dart';
import '../../domain/repositories/identity_verification_repository.dart';

class IdentityVerificationNotifier extends StateNotifier<AsyncValue<VerificationRequestModel?>> {
  final IdentityVerificationRepository _repository;
  final String _userId;

  IdentityVerificationNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadRequest() async {
    state = const AsyncLoading();
    try {
      final request = await _repository.getVerificationRequest(_userId);
      state = AsyncData(request);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<String?> uploadDocument(String documentType, String imagePath) async {
    try {
      return await _repository.uploadDocument(_userId, documentType, imagePath);
    } catch (e) {
      print('Error uploading document: $e');
      return null;
    }
  }

  Future<bool> submitVerification({
    required String fullName,
    required int age,
    required String email,
    String? nationalIdUrl,
    String? passportUrl,
    String? driversLicenseUrl,
    String? selfieUrl,
  }) async {
    try {
      state = const AsyncLoading();
      final request = await _repository.submitVerificationRequest(
        userId: _userId,
        fullName: fullName,
        age: age,
        email: email,
        nationalIdUrl: nationalIdUrl,
        passportUrl: passportUrl,
        driversLicenseUrl: driversLicenseUrl,
        selfieUrl: selfieUrl,
      );
      state = AsyncData(request);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final identityVerificationProvider = StateNotifierProvider<IdentityVerificationNotifier, AsyncValue<VerificationRequestModel?>>((ref) {
  final repository = ref.watch(identityVerificationRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  final notifier = IdentityVerificationNotifier(repository, user.id);
  notifier.loadRequest();
  return notifier;
});

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());