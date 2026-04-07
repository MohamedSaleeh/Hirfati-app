import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../translations.dart';
import '../../domain/models/auth_form_state.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_mode_selector.dart';
import '../widgets/fields_for_login.dart';
import '../widgets/fields_for_signup.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/user_type_selector.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  FormGroup? _loginForm;
  FormGroup? _signupForm;

  @override
  void dispose() {
    _loginForm?.dispose();
    _signupForm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(authFormProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.25, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const AuthHeader(),
                const SizedBox(height: 28),
                const AuthModeSelector(),
                const SizedBox(height: 24),
                if (formState.mode == AuthMode.signUp) const UserTypeSelector(),
                const SizedBox(height: 24),
                if (formState.mode == AuthMode.login) const FieldsForLogin(),
                if (formState.mode == AuthMode.signUp) const FieldsForSignup(),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: theme.colorScheme.outlineVariant),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR CONTINUE WITH'.i18n,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: theme.colorScheme.outlineVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SocialLoginButtons(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
