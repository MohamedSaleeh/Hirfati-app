import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_components.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _appNameController = TextEditingController(text: 'حرفتي');
  final _supportEmailController =
      TextEditingController(text: 'غير متوفر في جدول إعدادات عام');
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;
  bool _orderConfirmation = true;
  bool _orderStatus = true;
  bool _promotions = true;
  bool _hydrated = false;
  bool _saving = false;

  @override
  void dispose() {
    _appNameController.dispose();
    _supportEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(dashboardNotificationSettingsProvider);
    settingsAsync.whenData((settings) {
      if (_hydrated) return;
      _pushEnabled = settings.pushEnabled;
      _emailEnabled = settings.emailEnabled;
      _smsEnabled = settings.smsEnabled;
      _orderConfirmation = settings.orderConfirmation;
      _orderStatus = settings.orderStatus;
      _promotions = settings.promotions;
      _hydrated = true;
    });

    final canSave = settingsAsync.hasValue && !_saving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DashboardButton(
            label: _saving ? 'جار الحفظ' : 'حفظ التغييرات',
            icon: Icons.save,
            onPressed: canSave ? _save : null,
          ),
        ),
        const SizedBox(height: 16),
        DashboardPanel(
          title: 'إعدادات عامة',
          subtitle:
              'لا يوجد جدول إعدادات عام في المخطط الحالي؛ هذه الحقول للعرض فقط.',
          trailing: const Icon(Icons.tune, color: DashboardColors.primary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 700;

                  if (wide) {
                    return Row(
                      children: [
                        Expanded(
                          child: _DashboardTextInput(
                            label: 'اسم التطبيق',
                            controller: _appNameController,
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _DashboardTextInput(
                            label: 'البريد الإلكتروني للدعم',
                            controller: _supportEmailController,
                            textDirection: TextDirection.ltr,
                            enabled: false,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _DashboardTextInput(
                        label: 'اسم التطبيق',
                        controller: _appNameController,
                        enabled: false,
                      ),
                      const SizedBox(height: 14),
                      _DashboardTextInput(
                        label: 'البريد الإلكتروني للدعم',
                        controller: _supportEmailController,
                        textDirection: TextDirection.ltr,
                        enabled: false,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'شعار التطبيق',
                style: TextStyle(
                  color: DashboardColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 260,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DashboardColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: DashboardColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: DashboardColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: DashboardColors.border),
                      ),
                      child: const Icon(
                        Icons.handyman,
                        color: DashboardColors.muted,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DashboardButton(
                          label: 'رفع شعار جديد',
                          icon: Icons.upload_file,
                          outlined: true,
                          onPressed: null,
                        ),
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: null,
                          child: const Text(
                            'حذف',
                            style: TextStyle(color: DashboardColors.danger),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'رفع الشعار غير مفعل لأنه لا توجد خدمة ملفات أو إعدادات عامة مرتبطة بهذه اللوحة.',
                style: TextStyle(color: DashboardColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        DashboardPanel(
          title: 'إعدادات الإشعارات',
          subtitle:
              'تُحفظ هذه الخيارات في جدول notification_settings للحساب الإداري الحالي.',
          trailing: const Icon(
            Icons.notifications_active,
            color: DashboardColors.primary,
          ),
          child: settingsAsync.when(
            data: (_) => Column(
              children: [
                _SettingsSwitchTile(
                  title: 'إشعارات الدفع',
                  subtitle: 'تفعيل أو تعطيل الإشعارات الفورية لهذا الحساب.',
                  icon: Icons.notifications,
                  color: DashboardColors.primary,
                  value: _pushEnabled,
                  onChanged: (value) => setState(() => _pushEnabled = value),
                ),
                _SettingsSwitchTile(
                  title: 'إشعارات البريد الإلكتروني',
                  subtitle: 'استلام تنبيهات عبر البريد الإلكتروني عند توفرها.',
                  icon: Icons.email,
                  color: DashboardColors.info,
                  value: _emailEnabled,
                  onChanged: (value) => setState(() => _emailEnabled = value),
                ),
                _SettingsSwitchTile(
                  title: 'إشعارات الرسائل النصية',
                  subtitle:
                      'تفعيل إشعارات SMS لهذا الحساب إن كانت الخدمة متاحة.',
                  icon: Icons.sms,
                  color: DashboardColors.warning,
                  value: _smsEnabled,
                  onChanged: (value) => setState(() => _smsEnabled = value),
                ),
                _SettingsSwitchTile(
                  title: 'تأكيد الطلبات',
                  subtitle: 'تنبيهات مرتبطة بتأكيد إنشاء الطلبات.',
                  icon: Icons.task_alt,
                  color: DashboardColors.success,
                  value: _orderConfirmation,
                  onChanged: (value) =>
                      setState(() => _orderConfirmation = value),
                ),
                _SettingsSwitchTile(
                  title: 'تحديثات حالة الطلب',
                  subtitle: 'تنبيهات عند تغير حالة الطلب.',
                  icon: Icons.sync,
                  color: DashboardColors.primary,
                  value: _orderStatus,
                  onChanged: (value) => setState(() => _orderStatus = value),
                ),
                _SettingsSwitchTile(
                  title: 'العروض والتنبيهات العامة',
                  subtitle: 'تنبيهات العروض أو الرسائل العامة لهذا الحساب.',
                  icon: Icons.campaign,
                  color: DashboardColors.purple,
                  value: _promotions,
                  onChanged: (value) => setState(() => _promotions = value),
                ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(
                  color: DashboardColors.primary,
                ),
              ),
            ),
            error: (error, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'تعذر تحميل إعدادات الإشعارات: $error',
                  style: const TextStyle(
                    color: DashboardColors.danger,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: DashboardButton(
                    label: 'إعادة المحاولة',
                    icon: Icons.refresh,
                    outlined: true,
                    onPressed: () =>
                        ref.invalidate(dashboardNotificationSettingsProvider),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        DashboardPanel(
          title: 'إعدادات الأمان',
          subtitle:
              'لا توجد أعمدة أمان عامة في المخطط الحالي؛ هذه الخيارات غير قابلة للحفظ من اللوحة.',
          trailing: const Icon(Icons.shield, color: DashboardColors.primary),
          child: const Column(
            children: [
              _SettingsSwitchTile(
                title: 'المصادقة الثنائية',
                subtitle: 'غير متاحة للحفظ من الجداول الحالية.',
                icon: Icons.lock,
                color: DashboardColors.success,
                value: false,
                onChanged: null,
              ),
              _SettingsSwitchTile(
                title: 'تنبيهات الجلسات',
                subtitle: 'غير متاحة للحفظ من الجداول الحالية.',
                icon: Icons.devices,
                color: DashboardColors.info,
                value: false,
                onChanged: null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(dashboardAdminServiceProvider).saveMyNotificationSettings(
            DashboardNotificationSettings(
              pushEnabled: _pushEnabled,
              emailEnabled: _emailEnabled,
              smsEnabled: _smsEnabled,
              orderConfirmation: _orderConfirmation,
              orderStatus: _orderStatus,
              promotions: _promotions,
            ),
          );
      ref.invalidate(dashboardNotificationSettingsProvider);
      if (mounted) {
        _showMessage('تم حفظ إعدادات الإشعارات للحساب الحالي.');
      }
    } catch (error) {
      if (mounted) _showMessage('تعذر حفظ الإعدادات: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _DashboardTextInput extends StatelessWidget {
  const _DashboardTextInput({
    required this.label,
    required this.controller,
    this.textDirection = TextDirection.rtl,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final TextDirection textDirection;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: DashboardColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          textDirection: textDirection,
          style: const TextStyle(color: DashboardColors.text, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: DashboardColors.background,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: DashboardColors.border),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: DashboardColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: DashboardColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DashboardColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DashboardColors.border),
      ),
      child: Row(
        children: [
          Switch(
            value: value,
            activeThumbColor: DashboardColors.primary,
            onChanged: onChanged,
          ),
          const SizedBox(width: 12),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: DashboardColors.text,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: DashboardColors.muted,
                    fontSize: 11,
                    height: 1.4,
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
