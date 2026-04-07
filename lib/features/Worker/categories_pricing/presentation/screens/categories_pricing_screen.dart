import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../../translations.dart';
import '../providers/categories_pricing_provider.dart';
import '../widgets/add_service_dialog.dart';
import '../widgets/edit_service_dialog.dart';
import '../widgets/price_range_card.dart';
import '../widgets/service_card.dart';

class CategoriesPricingScreen extends ConsumerWidget {
  const CategoriesPricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(categoriesPricingProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('categories_pricing'.i18n.replaceAll('_', ' ')),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddServiceDialog(),
              );
            },
            child: Text(
              'add'.i18n,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: dataAsync.when(
        data: (data) {
          final (categories, services) = data;
          final category = categories.firstOrNull;

          if (category == null) {
            return Center(
              child: Text(
                'No category found'.i18n,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                PriceRangeCard(category: category),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'services'.i18n,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${services.length}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (services.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.build_outlined,
                          size: 48,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'no_services_added'.i18n.replaceAll('_', ' '),
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return ServiceCard(
                        service: service,
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                EditServiceDialog(service: service),
                          );
                        },
                        onDelete: () async {
                          final confirmed = await _showDeleteDialog(context);
                          if (confirmed) {
                            await ref
                                .read(categoriesPricingProvider.notifier)
                                .deleteService(service.id);
                          }
                        },
                      );
                    },
                  ),
                const SizedBox(height: 32),
              ],
            ),
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
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'error_loading_data'.i18n.replaceAll('_', ' '),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(categoriesPricingProvider),
                child: Text('retry'.i18n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    final theme = Theme.of(context);

    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('delete_service'.i18n.replaceAll('_', ' ')),
            content: Text(
              'delete_service_confirmation'.i18n.replaceAll('_', ' '),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('cancel'.i18n),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                child: Text('delete'.i18n),
              ),
            ],
          ),
        ) ??
        false;
  }
}
