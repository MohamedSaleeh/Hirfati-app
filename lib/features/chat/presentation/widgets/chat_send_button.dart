import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_form_provider.dart';
import '../providers/chat_provider.dart';

class ChatSendButton extends ConsumerWidget {
  final VoidCallback onPressed;

  const ChatSendButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasText = ref.watch(chatMessageHasTextProvider);
    final isSending = ref.watch(isSendingMessageProvider);

    return CircleAvatar(
      backgroundColor: hasText && !isSending
          ? colorScheme.primary
          : colorScheme.surfaceContainerHighest,
      child: IconButton(
        icon: Icon(
          Icons.send,
          color: hasText && !isSending
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          size: 18,
        ),
        onPressed: hasText && !isSending ? onPressed : null,
      ),
    );
  }
}
