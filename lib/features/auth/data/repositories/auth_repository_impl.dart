import '../../domain/models/auth_form_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_supabase_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthSupabaseDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String role,
  }) async {
    try {
      final response = await _datasource.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      await _datasource.insertProfile(
        id: user.id,
        fullName: fullName,
        role: role,
        phone: phoneNumber,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _datasource.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      throw Exception('Sign in failed');
    }
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  @override
  String? getCurrentUserId() {
    return _datasource.getCurrentUser()?.id;
  }

  @override
  Future<UserType> getCurrentUserRole() async {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception('No user logged in');
    }

    final profile = await _datasource.getUserRole(userId);
    final role = profile?['role'] as String?;

    if (role == null) {
      throw Exception('User role not found');
    }

    switch (role) {
      case 'worker':
        return UserType.worker;
      case 'client':
        return UserType.client;
      default:
        throw Exception('Unknown user role');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _datasource.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  @override
Future<bool> isWorkerProfileCompleted() async {
  final userId = getCurrentUserId();
  if (userId == null) {
    throw Exception('No user logged in');
  }
  return await _datasource.isWorkerProfileCompleted(userId);
}

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _datasource.getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }
      await _datasource.updateUserPassword(newPassword);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

 
}