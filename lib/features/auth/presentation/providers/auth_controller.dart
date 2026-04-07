import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/auth_providers.dart';
import '../../domain/models/auth_form_state.dart';

enum AuthStatus { none, authenticated }

class AuthController extends AsyncNotifier<AuthStatus> {
  @override
  Future<AuthStatus> build() async {
    final repo = ref.read(authRepositoryProvider);
    final userId = repo.getCurrentUserId();
    
    if (userId != null) {
      return AuthStatus.authenticated;
    }
    return AuthStatus.none;
  }

  Future<void> submit({required AuthFormState formState}) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      if (formState.mode == AuthMode.login) {
        await repo.signIn(email: formState.email, password: formState.password);
        state = const AsyncData(AuthStatus.authenticated);
      } else {
        print(
          "Attempting to sign up with: ${formState.email}, ${formState.fullName}, ${formState.phone}, Role: ${formState.userType}",
        );
        await repo.signUp(
          email: formState.email,
          password: formState.password,
          fullName: formState.fullName,
          phoneNumber: formState.phone,
          role: formState.userType.name,
        );
        await repo.signIn(email: formState.email, password: formState.password);
        state = const AsyncData(AuthStatus.authenticated);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      state = const AsyncValue.data(AuthStatus.none);
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<UserType?> getCurrentUserRole() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      return await repo.getCurrentUserRole();
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  Future<bool> isWorkerProfileCompleted() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      return await repo.isWorkerProfileCompleted();
    } catch (e) {
      print("Error checking worker profile completion: $e");
      return false;
    }
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthStatus>(AuthController.new);