import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/presentation/widgets/language_dialog_widget.dart';
import '../../../../../translations.dart';
import '../providers/worker_profile_provider.dart';
import '../widgets/worker_profile_header.dart';
import '../widgets/worker_stats_card.dart';
import '../widgets/worker_profile_menu_item.dart';

class WorkerProfileScreen extends ConsumerWidget {
  const WorkerProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(workerProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: profileAsync.when(
        data: (profile) {
          return CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,

                flexibleSpace: FlexibleSpaceBar(
                  background: WorkerProfileHeader(profile: profile),
                ),
              ),
              // Body
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Stats
                    WorkerStatsCard(
                      completedJobs: profile.completedJobs,
                      totalHours: profile.totalHours,
                    ),
                    const SizedBox(height: 24),
                    // Menu Items
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          WorkerProfileMenuItem(
                            icon: Icons.person_outline,
                            title: 'account settings'.i18n,
                            subtitle: 'personal data password'.i18n,
                            onTap: () {
                              context.push('/worker/account-settings');
                              ref.invalidate(workerProfileProvider);
                            },
                          ),

                          WorkerProfileMenuItem(
                            icon: Icons.language_outlined,
                            title: 'language'.i18n,
                            subtitle: 'select your preferred language'.i18n,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const LanguageDialogWidget(),
                              );
                            },
                          ),
                          const Divider(height: 1, indent: 60),
                          WorkerProfileMenuItem(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Wallet'.i18n,
                            subtitle: 'Current balance and payments'.i18n,
                            onTap: () {
                              context.push('/wallet');
                            },
                          ),
                          const Divider(height: 1, indent: 60),
                          WorkerProfileMenuItem(
                            icon: Icons.category_outlined,
                            title: 'categories pricing'.i18n,
                            subtitle: 'service engagement price list'.i18n,
                            onTap: () {
                              context.push('/worker/categories-pricing');
                            },
                          ),
                          const Divider(height: 1, indent: 60),
                          WorkerProfileMenuItem(
                            icon: Icons.verified_outlined,
                            title: 'identity verification'.i18n,
                            subtitle: profile.isVerified
                                ? 'verified account'.i18n
                                : 'not verified'.i18n,
                            onTap: profile.isVerified
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'account already verified'.i18n,
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                : () => context.push(
                                    '/worker/identity-verification',
                                  ),
                            trailing: profile.isVerified
                                ? Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 20,
                                  )
                                : null,
                            isDisabled: profile.isVerified,
                          ),
                          const Divider(height: 1, indent: 60),
                          WorkerProfileMenuItem(
                            icon: Icons.notifications_outlined,
                            title: 'notification settings'.i18n,
                            subtitle: 'alerts messages'.i18n,
                            onTap: () {
                              context.push('/notification-settings');
                            },
                          ),
                          const Divider(height: 1, indent: 60),
                          WorkerProfileMenuItem(
                            icon: Icons.help_outline,
                            title: 'help support'.i18n,
                            subtitle: 'faq contact us'.i18n,
                            onTap: () {
                              context.push('/help-support');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Sign Out Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: OutlinedButton.icon(
                        onPressed: () => _logout(context, ref),
                        icon: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        label: Text(
                          "logout".i18n,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Version
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Text(
                        'Version 2.4.1',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('error_loading_profile'.i18n),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(workerProfileProvider),
                child: Text('retry'.i18n),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
