import 'package:flutter/material.dart';
import '../../../../../translations.dart';

class VerificationGuidelines extends StatelessWidget {
  const VerificationGuidelines({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'verification_guidelines'.i18n.replaceAll('_', ' '),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGuidelineItem('guideline_1'.i18n, colorScheme),
          const SizedBox(height: 8),
          _buildGuidelineItem('guideline_2'.i18n, colorScheme),
          const SizedBox(height: 8),
          _buildGuidelineItem('guideline_3'.i18n, colorScheme),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(String text, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(color: colorScheme.primary)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
