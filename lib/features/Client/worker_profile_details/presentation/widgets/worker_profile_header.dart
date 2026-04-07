import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../translations.dart';
import '../../../../chat/data/providers/chat_providers.dart';
import '../../../../chat/presentation/providers/chat_controller.dart';
import '../../../../chat/presentation/providers/chat_provider.dart';
import '../../domain/models/worker_profile_details_model.dart';

class WorkerProfileHeader extends ConsumerStatefulWidget {
  final WorkerProfileDetailsModel details;

  const WorkerProfileHeader({super.key, required this.details});

  @override
  ConsumerState<WorkerProfileHeader> createState() =>
      _WorkerProfileHeaderState();
}

class _WorkerProfileHeaderState extends ConsumerState<WorkerProfileHeader> {
  bool _isCreatingChat = false;

  Future<void> _startChat() async {
    if (_isCreatingChat) return;

    setState(() {
      _isCreatingChat = true;
    });

    final workerId = widget.details.userId;
    final workerName = widget.details.fullName;
    final workerAvatar = widget.details.avatarUrl;

    print('🔵 Starting chat with worker: $workerId');

    try {
      final repository = ref.read(chatRepositoryProvider);
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final conversationId = await repository.getOrCreateConversation(
        currentUser.id,
        workerId,
      );

      print('✅ Conversation ID: $conversationId');

      if (mounted) {
        ref.read(conversationIdProvider.notifier).state = conversationId;
        ref.read(receiverIdProvider.notifier).state = workerId;

        context.push(
          '/chat/$conversationId',
          extra: {
            'userId': workerId,
            'userName': workerName,
            'userAvatar': workerAvatar,
          },
        );
      }
    } catch (e) {
      print('❌ Error starting chat: $e');
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting conversation: ${e.toString()}'.i18n),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingChat = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = widget.details;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 46,
              backgroundImage: details.avatarUrl != null
                  ? NetworkImage(details.avatarUrl!)
                  : null,
              child: details.avatarUrl == null
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              details.fullName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${details.categoryName} • ${details.experienceYears} ${'Years Experience'.i18n}",
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  value: details.ratingAverage.toStringAsFixed(1),
                  label: 'Rating'.i18n,
                  icon: Icons.star,
                  iconColor: theme.colorScheme.tertiary,
                ),
                _StatItem(
                  value: details.completedJobsCount.toString(),
                  label: 'Completed Jobs'.i18n,
                  icon: Icons.check_circle,
                  iconColor: theme.colorScheme.primary,
                ),
                _StatItem(
                  value: details.approved ? "100%" : "0%",
                  label: 'Verified'.i18n,
                  icon: Icons.verified,
                  iconColor: theme.colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: _isCreatingChat ? null : _startChat,
                icon: _isCreatingChat
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(
                  _isCreatingChat ? 'Starting...' : 'Send Message'.i18n,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (details.approved)
                  _Badge(
                    text: 'Verified Identity'.i18n,
                    color: theme.colorScheme.primaryContainer,
                    textColor: theme.colorScheme.onPrimaryContainer,
                  ),
                _Badge(
                  text: 'Competitive Prices'.i18n,
                  color: theme.colorScheme.secondaryContainer,
                  textColor: theme.colorScheme.onSecondaryContainer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: textColor)),
    );
  }
}
