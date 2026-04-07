import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/utils/image_utils.dart';
import '../../domain/models/order_photo_model.dart';
import '../../../../../translations.dart';

class PhotoGrid extends StatelessWidget {
  final List<OrderPhotoModel> photos;
  final VoidCallback onAddPhoto;
  final ValueChanged<int> onRemovePhoto;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 40 - 10) / 2;
    final itemHeight = itemWidth * 1.25;

    return SizedBox(
      height: itemHeight * 2 + 10,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.25,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index < photos.length) {
            return _buildPhotoItem(photos[index], index, context);
          }
          if (index == photos.length && photos.length < 4) {
            return _buildAddPhotoItem(context);
          }
          return _buildEmptyPhotoItem(context);
        },
      ),
    );
  }

  Widget _buildPhotoItem(
    OrderPhotoModel photo,
    int index,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildImage(photo, context),
        ),
        if (photo.isUploading)
          Container(
            color: colorScheme.shadow.withOpacity(0.5),
            child: Center(
              child: Lottie.asset(
                'assets/animations/loading_animation.json',
                width: 150,
                height: 150,
                repeat: true,
              ),
            ),
          ),
        PositionedDirectional(
          top: 6,
          end: 6,
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return InkWell(
                onTap: () => onRemovePhoto(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImage(OrderPhotoModel photo, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (photo.localPath == null) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Icon(Icons.image_outlined, color: colorScheme.onSurfaceVariant),
      );
    }

    return ImageUtils.buildPreview(
      photo.localPath,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildAddPhotoItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onAddPhoto,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 32,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo'.i18n,
              style: TextStyle(color: colorScheme.primary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPhotoItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.image_outlined, color: colorScheme.outline, size: 32),
      ),
    );
  }
}
