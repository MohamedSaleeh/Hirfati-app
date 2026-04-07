import 'package:flutter/material.dart';

class WorkerFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const WorkerFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? theme.colorScheme.error : null,
      ),
    );
  }
}
