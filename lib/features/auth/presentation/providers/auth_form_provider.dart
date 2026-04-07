import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/auth_form_state.dart';

final authFormProvider = NotifierProvider<AuthFormNotifier, AuthFormState>(
  AuthFormNotifier.new,
);

class AuthFormNotifier extends Notifier<AuthFormState> {
  @override
  AuthFormState build() => const AuthFormState();

  void setMode(AuthMode mode) {
    state = state.copyWith(mode: mode, errorMessage: null);
  }

  void setUserType(UserType userType) {
    state = state.copyWith(userType: userType);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value, errorMessage: null);
  }

  void setFullName(String value) {
    state = state.copyWith(fullName: value, errorMessage: null);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value, errorMessage: null);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }
  

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? message) {
    state = state.copyWith(errorMessage: message, isLoading: false);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
