import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../translations.dart';
import '../providers/notification_settings_provider.dart';
import '../widgets/settings_switch_tile.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('Notification Settings'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(
                context: context,
                title: 'Notification Channels'.i18n,
                children: [
                  SettingsSwitchTile(
                    title: 'Push Notifications'.i18n,
                    subtitle:
                        'Receive instant notifications on your device'.i18n,
                    value: settings.pushEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updatePushEnabled(value);
                    },
                  ),
                  SettingsSwitchTile(
                    title: 'Email Notifications'.i18n,
                    subtitle: 'Receive updates via email'.i18n,
                    value: settings.emailEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateEmailEnabled(value);
                    },
                  ),
                  SettingsSwitchTile(
                    title: 'SMS Notifications'.i18n,
                    subtitle: 'Receive text message alerts'.i18n,
                    value: settings.smsEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSmsEnabled(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                context: context,
                title: 'Order Notifications'.i18n,
                children: [
                  SettingsSwitchTile(
                    title: 'Order Confirmation'.i18n,
                    value: settings.orderConfirmation,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateOrderConfirmation(value);
                    },
                  ),
                  SettingsSwitchTile(
                    title: 'Order Status Updates'.i18n,
                    value: settings.orderStatus,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateOrderStatus(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                context: context,
                title: 'Promotional Notifications'.i18n,
                children: [
                  SettingsSwitchTile(
                    title: 'Special Offers & Promotions'.i18n,
                    value: settings.promotions,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updatePromotions(value);
                    },
                  ),
                ],
              ),
            ],
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
          child: Text(
            'Error: \$error'.i18n,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: children),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
