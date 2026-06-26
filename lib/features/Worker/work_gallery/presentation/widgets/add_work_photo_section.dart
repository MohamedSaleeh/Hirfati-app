import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../translations.dart';
import 'add_work_empty_photos.dart';
import 'add_work_photo_grid.dart';

class AddWorkPhotoSection extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onAddPhotos;
  final ValueChanged<int> onRemovePhoto;

  const AddWorkPhotoSection({
    super.key,
    required this.images,
    required this.onAddPhotos,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Photos',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddPhotos,
                  icon: const Icon(Icons.add_a_photo, size: 18),
                  label: Text(
                    'add_photos'.i18n,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: images.isEmpty
                ? const AddWorkEmptyPhotos()
                : AddWorkPhotoGrid(images: images, onRemove: onRemovePhoto),
          ),
        ],
      ),
    );
  }
}
