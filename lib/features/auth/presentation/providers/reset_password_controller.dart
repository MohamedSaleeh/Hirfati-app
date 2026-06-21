import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/providers/auth_providers.dart';
import '../../domain/models/reset_password_state.dart';

final resetPasswordControllerProvider =
    StateNotifierProvider<ResetPasswordController, ResetPasswordState>(
      (ref) => ResetPasswordController(ref),
    );

class ResetPasswordController extends StateNotifier<ResetPasswordState> {
  final Ref _ref;

  ResetPasswordController(this._ref) : super(const ResetPasswordState());

  Future<void> sendResetEmail(String email) async {
    if (email.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your email');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = _ref.read(authRepositoryProvider);
      await repository.sendPasswordResetEmail(email);
      print('[+] Password reset email sent to: $email successfully.');

      state = state.copyWith(isLoading: false, emailSent: true, email: email);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapErrorMessage(e.toString()),
      );
    }
  }

  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your new password');
      return;
    }

    if (newPassword.length < 6) {
      state = state.copyWith(
        errorMessage: 'Password must be at least 6 characters',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      state = state.copyWith(errorMessage: 'Passwords do not match');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = _ref.read(authRepositoryProvider);
      await repository.updatePassword(newPassword);

      state = state.copyWith(isLoading: false, emailSent: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapErrorMessage(e.toString()),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const ResetPasswordState();
  }

  String _mapErrorMessage(String error) {
    if (error.contains('User not found')) {
      return 'No account found with this email address';
    }
    if (error.contains('rate limit')) {
      return 'Too many attempts. Please try again later';
    }
    return 'Something went wrong. Please try again';
  }
}
