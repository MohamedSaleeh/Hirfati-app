import '../../domain/models/auth_form_state.dart';

abstract class AuthRepository {
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String role,
  });

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  String? getCurrentUserId();

  Future<UserType> getCurrentUserRole();

  Future<bool> isWorkerProfileCompleted();

  Future<void> sendPasswordResetEmail(String email);
  Future<void> updatePassword(String newPassword);
}
