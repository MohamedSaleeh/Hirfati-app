import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../translations.dart';

class FaceUploadCard extends StatelessWidget {
  final bool isUploaded;
  final ValueChanged<String?> onUpload;

  const FaceUploadCard({
    super.key,
    required this.isUploaded,
    required this.onUpload,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (image != null) {
      onUpload(image.path);
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
          Row(
            children: [
              Icon(Icons.face, size: 24, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'face_verification'.i18n.replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'selfie_match_description'.i18n.replaceAll('_', ' '),
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isUploaded
                    ? colorScheme.primaryContainer.withOpacity(0.3)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUploaded
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isUploaded ? Icons.check_circle : Icons.camera_alt,
                      size: 40,
                      color: isUploaded
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUploaded
                          ? 'uploaded'.i18n
                          : 'tap_to_upload_face'.i18n.replaceAll('_', ' '),
                      style: TextStyle(
                        color: isUploaded
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
