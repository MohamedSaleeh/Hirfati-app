import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../translations.dart';
import '../providers/create_order_provider.dart';
import '../widgets/category_selector.dart';
import '../widgets/service_selector.dart';

class Step1DescriptionScreen extends ConsumerWidget {
  const Step1DescriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createOrderProvider);
    final notifier = ref.read(createOrderProvider.notifier);
    final description = state.order.description;
    final isDirectBooking = state.isDirectBooking;
    final selectedServiceId = state.selectedServiceId;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us what you need help with'.i18n,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be as specific as possible so the craftsman knows what to bring.'
                .i18n,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          if (!isDirectBooking) ...[
            Text(
              'Service Category'.i18n,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            CategorySelector(
              categories: state.categories,
              selectedCategoryId: state.order.categoryId,
              enabled: !state.lockCategory,
              onSelect: (cat) => notifier.setCategory(cat.id, cat.name),
            ),
          ] else ...[
            Text(
              'Select a service'.i18n,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ServiceSelector(
              services: state.workerServices,
              selectedServiceId: selectedServiceId,
              onSelect: (service) => notifier.selectService(service),
            ),
            if (state.workerServices.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'This craftsman has no predefined services. Please describe your need.'
                    .i18n,
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ],

          const SizedBox(height: 20),

          Text(
            'Description'.i18n,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 7,
            maxLength: 500,
            initialValue: description,
            onChanged: notifier.setDescription,
            decoration: InputDecoration(
              hintText: isDirectBooking
                  ? 'Add any special instructions (optional)'.i18n
                  : 'e.g., My kitchen sink is leaking underneath the cabinet.'
                        .i18n,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '${description.length}/500'.i18n,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),

          if (!isDirectBooking &&
              description.length < 20 &&
              description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Please provide at least 20 characters describing your issue'
                    .i18n,
                style: TextStyle(color: colorScheme.error, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
