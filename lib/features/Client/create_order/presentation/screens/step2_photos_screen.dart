import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/image_picker_widget.dart';
import '../../../../../translations.dart';
import '../providers/create_order_provider.dart';
import '../widgets/photo_grid.dart';

class Step2PhotosScreen extends ConsumerWidget {
  const Step2PhotosScreen({super.key});

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => ImagePickerWidget(
        onImagePicked: (path) async {
          final notifier = ref.read(createOrderProvider.notifier);
          try {
            await notifier.addPhoto(path);
          } catch (e, stack) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}'.i18n)),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createOrderProvider);
    final notifier = ref.read(createOrderProvider.notifier);
    final hasPhotos = state.order.photos.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Photos of the Issue'.i18n,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clear photos help the craftsman give a more accurate estimate.'
                .i18n,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${state.order.photos.length} ${'of'.i18n} 4 ${'photos added'.i18n}',
                style: TextStyle(
                  color: hasPhotos ? colorScheme.primary : colorScheme.error,
                  fontWeight: hasPhotos ? FontWeight.normal : FontWeight.w600,
                ),
              ),
              if (!hasPhotos) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: colorScheme.error,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (!hasPhotos)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please add at least one photo to continue'.i18n,
                      style: TextStyle(
                        color: colorScheme.onErrorContainer,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          PhotoGrid(
            photos: state.order.photos,
            onAddPhoto: () => _pickPhoto(context, ref),
            onRemovePhoto: notifier.removePhoto,
          ),
          const SizedBox(height: 16),
          if (!hasPhotos)
            Center(
              child: TextButton.icon(
                onPressed: () {
                  _showHelpDialog(context);
                },
                icon: Icon(
                  Icons.help_outline,
                  size: 16,
                  color: colorScheme.primary,
                ),
                label: Text(
                  'Why do I need to upload photos?'.i18n,
                  style: TextStyle(color: colorScheme.primary, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.photo_camera_outlined, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Why upload photos?'.i18n,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Photos help the craftsman understand your issue better.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildHelpBulletPoint(
              context,
              Icons.check_circle_outline,
              'Get more accurate estimates',
            ),
            const SizedBox(height: 12),
            _buildHelpBulletPoint(
              context,
              Icons.check_circle_outline,
              'Craftsman can bring the right tools',
            ),
            const SizedBox(height: 12),
            _buildHelpBulletPoint(
              context,
              Icons.check_circle_outline,
              'Faster service completion',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
            child: Text('Got it'.i18n),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpBulletPoint(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text.i18n,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
