// lib/features/review/presentation/widgets/review_comment_section.dart
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../translations.dart';

class ReviewCommentSection extends StatelessWidget {
  final FormGroup form;

  const ReviewCommentSection({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a review (optional)'.i18n,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ReactiveForm(
            formGroup: form,
            child: ReactiveTextField(
              formControlName: 'comment',
              decoration: InputDecoration(
                hintText: 'Share your experience...'.i18n,
                hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}
