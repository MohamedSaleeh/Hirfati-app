import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../translations.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_form_provider.dart';
import '../providers/signup_form_provider.dart';

class FieldsForSignup extends ConsumerWidget {
  const FieldsForSignup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formGroup = ref.watch(signupFormProvider);
    final formState = ref.watch(authFormProvider);
    final authState = ref.watch(authControllerProvider);

    final authController = ref.read(authControllerProvider.notifier);
    final formNotifier = ref.read(authFormProvider.notifier);

    return ReactiveForm(
      formGroup: formGroup,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReactiveTextField<String>(
            formControlName: 'fullName',
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              context,
              hint: 'Full Name'.i18n,
              icon: Icons.person_outline,
            ),
            onChanged: (c) => formNotifier.setFullName(c.value ?? ''),
          ),

          const SizedBox(height: 16),

          ReactiveTextField<String>(
            formControlName: 'email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              context,
              hint: 'Email'.i18n,
              icon: Icons.email_outlined,
            ),
            onChanged: (c) => formNotifier.setEmail(c.value ?? ''),
          ),

          const SizedBox(height: 16),

          ReactiveTextField<String>(
            formControlName: 'phoneNumber',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              context,
              hint: 'Phone Number'.i18n,
              icon: Icons.phone_outlined,
            ),
            onChanged: (c) => formNotifier.setPhone(c.value ?? ''),
          ),

          const SizedBox(height: 16),

          ReactiveTextField<String>(
            formControlName: 'password',
            obscureText: formState.obscurePassword,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              context,
              hint: 'Password'.i18n,
              icon: Icons.lock_outline,
              suffix: IconButton(
                icon: Icon(
                  formState.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: formNotifier.toggleObscurePassword,
              ),
            ),
            onChanged: (c) => formNotifier.setPassword(c.value ?? ''),
          ),

          const SizedBox(height: 16),

          ReactiveTextField<String>(
            formControlName: 'confirmPassword',
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: _inputDecoration(
              context,
              hint: 'Confirm Password'.i18n,
              icon: Icons.lock_outline,
            ),
            onChanged: (control) => ref.read(authFormProvider),
          ),

          const SizedBox(height: 24),

          authState.when(
            data: (_) => const SizedBox(),
            loading: () => const SizedBox(),
            error: (error, _) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _mapError(error.toString()).i18n,
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          authState.when(
            data: (_) => _buildButton(
              context,
              formGroup,
              onPressed: () {
                authController.submit(formState: formState);
              },
            ),
            loading: () => Center(
              child: Lottie.asset(
                'assets/animations/loading_animation.json',
                width: 150,
                height: 150,
                repeat: true,
              ),
            ),
            error: (_, _) => _buildButton(
              context,
              formGroup,
              onPressed: () {
                authController.submit(formState: formState);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    FormGroup formGroup, {
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilledButton(
      onPressed: () {
        if (formGroup.valid) {
          onPressed();
        } else {
          formGroup.markAllAsTouched();
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create Account'.i18n,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      prefixIcon: Icon(icon, size: 22, color: colorScheme.onSurfaceVariant),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  String _mapError(String error) {
    if (error.contains('already')) {
      return 'User already exists';
    }
    if (error.contains('invalid')) {
      return 'Invalid email';
    }
    if (error.contains('weak')) {
      return 'Weak password';
    }
    return 'Something went wrong';
  }
}
