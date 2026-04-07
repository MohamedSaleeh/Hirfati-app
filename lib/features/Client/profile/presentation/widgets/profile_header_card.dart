import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../../translations.dart';
import '../../domain/models/client_profile.dart';
import '../providers/client_profile_provider.dart';

class ProfileHeaderCard extends ConsumerWidget {
  const ProfileHeaderCard({
    super.key,
    required ClientProfile profile,
    required Null Function() onEditTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(clientProfileProvider);

    return profileAsync.when(
      data: (profile) {
        return _ProfileHeaderContent(
          profile: profile,
          onAvatarTap: () async {
            try {
              final notifier = ref.read(clientProfileProvider.notifier);
              await notifier.pickAndUploadAvatar();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile picture updated successfully'.i18n),
                    backgroundColor: theme.colorScheme.tertiary,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update profile picture'.i18n),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            }
          },
          onEditTap: () {
            context.push('/edit-profile');
          },
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
      error: (error, _) => Center(child: Text('Error: $error'.i18n)),
    );
  }
}

class _ProfileHeaderContent extends StatelessWidget {
  final ClientProfile profile;
  final VoidCallback onAvatarTap;
  final VoidCallback onEditTap;

  const _ProfileHeaderContent({
    required this.profile,
    required this.onAvatarTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primaryContainer,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        size: 40,
                        color: theme.colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onAvatarTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName ?? "User",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (profile.phoneNumber != null) ...[
            const SizedBox(height: 4),
            Text(
              profile.phoneNumber!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onEditTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text("edit_profile".i18n),
          ),
        ],
      ),
    );
  }
}
