import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../translations.dart';

class IdUploadCard extends StatelessWidget {
  final String title;
  final ValueChanged<String?> onFrontUploaded;
  final ValueChanged<String?> onBackUploaded;
  final bool frontUploaded;
  final bool backUploaded;

  const IdUploadCard({
    super.key,
    required this.title,
    required this.onFrontUploaded,
    required this.onBackUploaded,
    required this.frontUploaded,
    required this.backUploaded,
  });

  Future<void> _pickImage(bool isFront) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (image != null) {
      if (isFront) {
        onFrontUploaded(image.path);
      } else {
        onBackUploaded(image.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildUploadButton(
                  context: context,
                  label: 'front_side'.i18n,
                  isUploaded: frontUploaded,
                  onTap: () => _pickImage(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUploadButton(
                  context: context,
                  label: 'back_side'.i18n,
                  isUploaded: backUploaded,
                  onTap: () => _pickImage(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton({
    required String label,
    required bool isUploaded,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isUploaded
              ? colorScheme.primaryContainer.withOpacity(0.3)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUploaded ? Icons.check_circle : Icons.cloud_upload_outlined,
              color: isUploaded
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              isUploaded ? 'uploaded'.i18n : label,
              style: TextStyle(
                color: isUploaded
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: isUploaded ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
