import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../translations.dart';
import '../providers/create_order_provider.dart';
import '../widgets/address_card.dart';
import '../widgets/time_slot_selector.dart';

class Step3LocationScreen extends ConsumerWidget {
  const Step3LocationScreen({super.key});

  Future<void> _editAddress(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.read(createOrderProvider);
    final controller = TextEditingController(text: state.order.address ?? '');

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.location_on_outlined, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text('Service Address'.i18n),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter your full address'.i18n,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.i18n),
          ),
          FilledButton(
            onPressed: () {
              final address = controller.text.trim();
              if (address.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter an address'.i18n),
                    backgroundColor: colorScheme.error,
                  ),
                );
                return;
              }
              Navigator.pop(context, address);
            },
            child: Text('Save'.i18n),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    final prev = ref.read(createOrderProvider).order;
    ref
        .read(createOrderProvider.notifier)
        .setLocation(result, prev.latitude ?? 0, prev.longitude ?? 0);
  }

  Future<void> _pickDateTime(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = ref.read(createOrderProvider.notifier);
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: colorScheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: colorScheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;
    notifier.setSchedule(date, time);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createOrderProvider);
    final notifier = ref.read(createOrderProvider.notifier);

    final hasAddress =
        state.order.address != null && state.order.address!.trim().isNotEmpty;
    final hasSchedule =
        state.order.scheduledDate != null && state.order.scheduledTime != null;

    final scheduleText = !hasSchedule
        ? 'Select date and time'.i18n
        : '${state.order.scheduledDate!.toLocal().toString().split(' ').first} - ${state.order.scheduledTime!.format(context)}';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm Location & Schedule'.i18n,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us where and when you need the service'.i18n,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Service Address'.i18n,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          AddressCard(
            address: state.order.address,
            onEdit: () => _editAddress(context, ref),
          ),

          if (!hasAddress)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Address is required'.i18n,
                    style: TextStyle(fontSize: 12, color: colorScheme.error),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          Text(
            'Preferred Date & Time'.i18n,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: !hasSchedule
                    ? colorScheme.error.withOpacity(0.5)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              title: Text(
                scheduleText,
                style: TextStyle(
                  color: !hasSchedule
                      ? colorScheme.error
                      : colorScheme.onSurface,
                  fontWeight: !hasSchedule
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
              trailing: Icon(
                Icons.calendar_month_outlined,
                color: colorScheme.primary,
              ),
              onTap: () => _pickDateTime(context, ref),
            ),
          ),

          if (!hasSchedule)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Date and time are required'.i18n,
                    style: TextStyle(fontSize: 12, color: colorScheme.error),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          Text(
            'Preferred Time Slot'.i18n,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TimeSlotSelector(
            selected: state.order.preferredTimeSlot,
            onChanged: notifier.setTimeSlot,
          ),
          const SizedBox(height: 20),

          Text(
            'Access Instructions'.i18n,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            minLines: 2,
            maxLines: 3,
            onChanged: notifier.setAccessInstructions,
            decoration: InputDecoration(
              hintText:
                  'e.g., Gate code, parking instructions, building number'.i18n,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Make sure the address and time are correct. The craftsman will use this information to reach you.'
                        .i18n,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
