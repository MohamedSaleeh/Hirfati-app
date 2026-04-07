import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../translations.dart';
import '../providers/chat_form_provider.dart';
import 'chat_send_button.dart';

class ChatInputField extends ConsumerWidget {
  final VoidCallback onSendMessage;
  final VoidCallback onPickImage;

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final form = ref.watch(chatFormProvider);
    final updateForm = ref.read(chatFormUpdateProvider);
    final resetForm = ref.read(chatFormResetProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ReactiveForm(
        formGroup: form,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo, color: colorScheme.onSurfaceVariant),
              onPressed: onPickImage,
            ),
            Expanded(
              child: ReactiveTextField(
                formControlName: 'message',
                decoration: InputDecoration(
                  hintText: 'Type a message'.i18n,
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) {
                  updateForm();
                },
                onSubmitted: (_) {
                  if (ref.read(chatMessageHasTextProvider)) {
                    onSendMessage();
                    resetForm();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            ChatSendButton(
              onPressed: () {
                onSendMessage();
                resetForm();
              },
            ),
          ],
        ),
      ),
    );
  }
}
