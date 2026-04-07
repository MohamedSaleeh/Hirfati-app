import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../translations.dart';
import '../providers/chat_provider.dart';
import 'message_bubble.dart';

class ChatMessageList extends ConsumerWidget {
  final ScrollController scrollController;

  const ChatMessageList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final messagesAsync = ref.watch(chatMessagesStreamProvider);

    return messagesAsync.when(
      data: (messages) {
        if (messages.isEmpty) {
          return _buildEmptyChat(context);
        }
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          reverse: false,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final currentUser = Supabase.instance.client.auth.currentUser;
            final isMe = message.senderId == currentUser?.id;
            return MessageBubble(
              message: message,
              isMe: isMe,
              onLongPress: () {},
            );
          },
        );
      },
      loading: () => _buildLoadingState(context),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error loading messages'.i18n),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(chatMessagesStreamProvider);
              },
              child: Text('Retry'.i18n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading messages...'.i18n,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text('Start a conversation'.i18n, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Say hello to someone'.i18n,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
