import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../../translations.dart';

import '../providers/address_formgroup_provider.dart';
import '../providers/addresses_provider.dart';
import '../widgets/address_card.dart';

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Addresses'.i18n),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(selectedAddressProvider.notifier).state = null;
              context.push('/add-address');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return AddressCard(
                address: addresses[index],
                onEdit: () =>
                    context.push('/edit-address', extra: addresses[index]),
                onDelete: () async {
                  final confirmed = await _showDeleteDialog(context);
                  if (confirmed) {
                    await ref
                        .read(addressesProvider.notifier)
                        .deleteAddress(addresses[index].id as String);
                  }
                },
                onSetDefault: () {
                  ref
                      .read(addressesProvider.notifier)
                      .setDefaultAddress(addresses[index].id as String);
                },
                onSelect: () => context.pop(addresses[index]),
              );
            },
          );
        },
        loading: () => Center(
          child: Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
        error: (error, _) => Center(child: Text('Error: \$error'.i18n)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved addresses'.i18n,
            style: TextStyle(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/add-address'),
            icon: const Icon(Icons.add),
            label: Text('Add Address'.i18n),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'.i18n),
        content: Text('Are you sure you want to delete this address?'.i18n),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'.i18n),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: Text('Delete'.i18n),
          ),
        ],
      ),
    );
  }
}
