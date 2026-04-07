import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/presentation/widgets/language_dialog_widget.dart';
import '../../../../../translations.dart';
import '../../../completeProfile/presentation/providers/profile_setup_controller.dart';
import '../providers/client_profile_provider.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_item.dart';

class ClientProfileScreen extends ConsumerStatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  ConsumerState<ClientProfileScreen> createState() =>
      _ClientProfileScreenState();
}

class _ClientProfileScreenState extends ConsumerState<ClientProfileScreen> {
  bool _isProfileCompleted = false;
  bool _hasCompletedOnboarding = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileStatus();
  }

  Future<void> _loadProfileStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isProfileCompleted = await ref
          .read(profileSetupProvider.notifier)
          .checkProfileCompleted();

      final hasCompletedOnboarding = await ref
          .read(profileSetupProvider.notifier)
          .checkProfileCompletedForUser();

      setState(() {
        _isProfileCompleted = isProfileCompleted;
        _hasCompletedOnboarding = hasCompletedOnboarding;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading profile status: $e');
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        context.go('/auth');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging out'.i18n)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(clientProfileProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(
          "profile_title".i18n,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (_isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animations/loading_animation.json',
                width: 150,
                height: 150,
                repeat: true,
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeaderCard(profile: profile, onEditTap: () {}),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildMenuSection(context, [
                        ProfileMenuItem(
                          icon: Icons.account_circle,
                          title: "complete data profile".i18n,
                          subtitle: "data profile",
                          onTap: () {
                            context.push('/profile-setup');
                          },
                          enable:
                              (!_isProfileCompleted && _hasCompletedOnboarding)
                              ? true
                              : false,
                        ),
                        ProfileMenuItem(
                          icon: Icons.location_on,
                          title: "saved_addresses".i18n,
                          subtitle: "Home, Office",
                          onTap: () {
                            context.push('/saved-addresses');
                          },
                          enable: true,
                        ),
                        _buildDivider(context),
                        ClipRect(
                          child: Banner(
                            color: theme.colorScheme.error,
                            location: BannerLocation.topEnd,
                            message: "soon".i18n,
                            textStyle: TextStyle(
                              color: theme.colorScheme.surfaceBright,
                              fontWeight: FontWeight.bold,
                            ),
                            child: ProfileMenuItem(
                              icon: Icons.payment,
                              title: "payment_methods".i18n,
                              subtitle: "Visa ending in 4242",
                              onTap: () {
                                context.push('/payment-methods');
                              },
                              enable: false,
                            ),
                          ),
                        ),
                        ProfileMenuItem(
                          icon: Icons.wallet,
                          title: 'Sham Cash Account'.i18n,
                          subtitle: '********************'.i18n,
                          onTap: () {
                            context.push('/sham-cash-details');
                          },
                          enable: true,
                        ),
                        ProfileMenuItem(
                          icon: Icons.lock,
                          title: "set pin".i18n,
                          subtitle: "Set your 4-digit PIN",
                          onTap: () {
                            context.push('/set-pin');
                          },
                          enable: true,
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _buildMenuSection(context, [
                        ProfileMenuItem(
                          icon: Icons.language,
                          title: "language".i18n,
                          subtitle: "Change Language".i18n,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const LanguageDialogWidget(),
                            );
                          },
                          enable: true,
                        ),
                        ProfileMenuItem(
                          icon: Icons.notifications,
                          title: "notifications".i18n,
                          subtitle: "Push, Email, SMS",
                          onTap: () => context.push('/notification-settings'),
                          enable: true,
                        ),
                        _buildDivider(context),
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: "help_support".i18n,
                          subtitle: "FAQ, Contact Us",
                          onTap: () => context.push('/help-support'),
                          enable: true,
                        ),
                      ]),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _logout(context),
                          icon: Icon(
                            Icons.logout,
                            color: theme.colorScheme.error,
                          ),
                          label: Text(
                            "logout".i18n,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            side: BorderSide(color: theme.colorScheme.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Center(
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Error loading profile: $error'.i18n),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(clientProfileProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: Text('Retry'.i18n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);

    return Divider(
      height: 1,
      thickness: 1,
      indent: 64,
      endIndent: 16,
      color: theme.colorScheme.surfaceContainerHighest,
    );
  }
}
