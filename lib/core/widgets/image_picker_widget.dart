import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../translations.dart';

class ImagePickerWidget extends StatelessWidget {
  final ValueChanged<String> onImagePicked;

  const ImagePickerWidget({super.key, required this.onImagePicked});

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (image == null || !context.mounted) return;
    onImagePicked(image.path);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text('Camera'.i18n),
              onTap: () => _pick(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text('Gallery'.i18n),
              onTap: () => _pick(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

