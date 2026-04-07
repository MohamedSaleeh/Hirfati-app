import 'package:flutter/material.dart';

import '../../../../../translations.dart';

class AddressCard extends StatelessWidget {
  final String? address;
  final VoidCallback onEdit;

  const AddressCard({super.key, required this.address, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(Icons.home_work_outlined, color: colorScheme.primary),
        title: Text(
          'Service Address'.i18n,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        subtitle: Text(
          (address == null || address!.trim().isEmpty)
              ? 'No address selected'.i18n
              : address!,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        trailing: IconButton(
          onPressed: onEdit,
          icon: Icon(
            Icons.edit_location_alt_outlined,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
