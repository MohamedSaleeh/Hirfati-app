import 'package:flutter/material.dart';

import '../models/dashboard_models.dart';
import '../theme/dashboard_colors.dart';
import 'dashboard_components.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.section});

  final DashboardSection section;

  @override
  Widget build(BuildContext context) {
    final meta = _sectionMeta(section);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: DashboardColors.background,
        border: Border(
          bottom: BorderSide(color: Color(0x141D2B3D)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showSearch = constraints.maxWidth > 620;
          return Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meta.title,
                      style: const TextStyle(
                        color: DashboardColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta.subtitle,
                      style: const TextStyle(
                        color: DashboardColors.muted,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showSearch) ...[
                SizedBox(
                  width: 270,
                  child: DashboardSearchField(
                    hint: 'بحث سريع...',
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 12),
              ],
              DashboardIconAction(
                icon: Icons.notifications_none,
                tooltip: 'الإشعارات',
                onPressed: () {},
                color: DashboardColors.primary,
              ),
            ],
          );
        },
      ),
    );
  }

  _HeaderMeta _sectionMeta(DashboardSection section) {
    return switch (section) {
      DashboardSection.overview => const _HeaderMeta(
          'نظرة عامة',
          'مرحباً بك مجدداً، إليك ما يحدث اليوم في منصتك.',
        ),
      DashboardSection.users => const _HeaderMeta(
          'إدارة المستخدمين',
          'استعرض وقم بإدارة حسابات العملاء والحرفيين.',
        ),
      DashboardSection.verification => const _HeaderMeta(
          'طلبات التوثيق المعلقة',
          'راجع واعتمد طلبات الحرفيين الجدد للانضمام للمنصة.',
        ),
      DashboardSection.complaints => const _HeaderMeta(
          'إدارة الشكاوى',
          'عرض ومعالجة النزاعات بين العملاء والحرفيين.',
        ),
      DashboardSection.deletions => const _HeaderMeta(
          'سجل المحذوفات',
          'سجل تدقيق كامل للحسابات المحذوفة من المنصة.',
        ),
      DashboardSection.settings => const _HeaderMeta(
          'الإعدادات العامة',
          'تخصيص إعدادات المنصة وإدارة التنبيهات.',
        ),
    };
  }
}

class _HeaderMeta {
  const _HeaderMeta(this.title, this.subtitle);

  final String title;
  final String subtitle;
}
