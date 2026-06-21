import 'package:flutter/material.dart';
import '../../../../../translations.dart';

class AddWorkEmptyPhotos extends StatelessWidget {
  const AddWorkEmptyPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'no_photos_selected'.i18n,
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          Text(
            'tap_add_photos_to_upload'.i18n,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}