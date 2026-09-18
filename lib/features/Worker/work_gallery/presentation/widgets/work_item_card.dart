import 'package:flutter/material.dart';
import '../../../../../translations.dart';
import '../../domain/models/work_item_model.dart';

class WorkItemCard extends StatelessWidget {
  final WorkItemModel item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const WorkItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });
  
  Widget _buildWorkImage() {
  const height = 180.0;

  if (item.imageUrls.isEmpty) {
    return _buildImagePlaceholder();
  }

  final imageUrl = item.imageUrls.first.trim();

  if (imageUrl.isEmpty) {
    return _buildImagePlaceholder();
  }

  final uri = Uri.tryParse(imageUrl);

  final isValidNetworkUrl =
      uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;

  if (!isValidNetworkUrl) {
    debugPrint(
      'Invalid portfolio image URL: $imageUrl',
    );

    return _buildImagePlaceholder();
  }

  return Image.network(
    imageUrl,
    height: height,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) {
      debugPrint(
        'Failed to load portfolio image: $imageUrl',
      );
      debugPrint('Error: $error');

      return _buildImagePlaceholder();
    },
  );
}

Widget _buildImagePlaceholder() {
  return Container(
    height: 180,
    width: double.infinity,
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: const Icon(
      Icons.broken_image_outlined,
      size: 48,
      color: Colors.grey,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final complexityColor = item.complexity == WorkComplexity.high
        ? Colors.orange
        : item.complexity == WorkComplexity.critical
        ? Colors.red
        : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
        ClipRRect(
  borderRadius: const BorderRadius.vertical(
    top: Radius.circular(20),
  ),
  child: _buildWorkImage(),
),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: complexityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getComplexityText(item.complexity),
                        style: TextStyle(
                          fontSize: 10,
                          color: complexityColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Stats and actions
                Row(
                  children: [
                    _buildStat(Icons.visibility, '${item.views ?? 0}'),
                    const SizedBox(width: 16),
                    _buildStat(Icons.star, '${item.rating?.toStringAsFixed(1) ?? '0.0'}'),
                    const Spacer(),
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        'view_details'.i18n,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, size: 18, color: Colors.red),
                              const SizedBox(width: 8),
                              Text('delete'.i18n, style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') onDelete();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  String _getComplexityText(WorkComplexity complexity) {
    switch (complexity) {
      case WorkComplexity.high:
        return 'HIGH COMPLEXITY'.i18n;
      case WorkComplexity.critical:
        return 'CRITICAL TASK'.i18n;
      default:
        return 'STANDARD'.i18n;
    }
  }
}