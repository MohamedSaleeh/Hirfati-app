import 'package:flutter/material.dart';

import '../models/dashboard_models.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_components.dart';

class DeletionsPage extends StatefulWidget {
  const DeletionsPage({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  State<DeletionsPage> createState() => _DeletionsPageState();
}

class _DeletionsPageState extends State<DeletionsPage> {
  String _query = '';
  String _role = 'all';
  String _days = 'all';

  @override
  Widget build(BuildContext context) {
    final records = widget.snapshot.deletionRecords.where((record) {
      final q = _query.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          record.accountName.toLowerCase().contains(q) ||
          record.phone.toLowerCase().contains(q) ||
          record.city.toLowerCase().contains(q) ||
          record.reason.toLowerCase().contains(q) ||
          record.deletedBy.toLowerCase().contains(q);
      final matchesRole = _role == 'all' || record.role == _role;
      final matchesDate = _days == 'all' ||
          DateTime.now().difference(record.deletedAt).inDays <=
              int.parse(_days);
      return matchesSearch && matchesRole && matchesDate;
    }).toList();

    final roles = {
      'all': 'تصفية حسب الدور',
      for (final record in widget.snapshot.deletionRecords)
        record.role: record.role,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DashboardBadge(
          label:
              'لا يوجد جدول سجل حذف مخصص؛ يتم عرض الحسابات غير النشطة من profiles فقط',
          color: DashboardColors.warning,
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 14),
        DashboardPanel(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DashboardResponsiveBox(
                preferredWidth: 320,
                minWidth: 220,
                child: DashboardSearchField(
                  hint: 'بحث بالاسم، الهاتف، المدينة، أو السبب...',
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 190,
                child: DashboardSelect<String>(
                  value: _role,
                  items: roles,
                  onChanged: (value) {
                    if (value != null) setState(() => _role = value);
                  },
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 160,
                child: DashboardSelect<String>(
                  value: _days,
                  items: const {
                    'all': 'كل التواريخ',
                    '30': 'آخر 30 يوم',
                    '90': 'آخر 90 يوم',
                  },
                  onChanged: (value) {
                    if (value != null) setState(() => _days = value);
                  },
                ),
              ),
              DashboardButton(
                label: 'تصدير CSV',
                icon: Icons.download,
                outlined: true,
                onPressed: () => _showMessage('تصدير CSV غير متاح حالياً.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DashboardPanel(
          padding: EdgeInsets.zero,
          child: records.isEmpty
              ? const DashboardEmptyState(
                  title: 'لا توجد حسابات غير نشطة',
                  message: 'لا توجد نتائج مطابقة للبحث الحالي.',
                )
              : Column(
                  children: [
                    DashboardTableFrame(
                      minWidth: 1040,
                      child: DataTable(
                        headingRowColor:
                            WidgetStateProperty.all(DashboardColors.surfaceAlt),
                        dataRowColor:
                            WidgetStateProperty.all(DashboardColors.surface),
                        columnSpacing: 26,
                        columns: const [
                          DataColumn(label: Text('الحساب غير النشط')),
                          DataColumn(label: Text('الهاتف')),
                          DataColumn(label: Text('المدينة')),
                          DataColumn(label: Text('الدور')),
                          DataColumn(label: Text('سبب التعطيل')),
                          DataColumn(label: Text('آخر تحديث')),
                          DataColumn(label: Text('المسؤول المنفذ')),
                          DataColumn(label: Text('التفاصيل')),
                        ],
                        rows: records.take(10).map((record) {
                          return DataRow(
                            color: WidgetStateProperty.all(
                              record.isSuspicious
                                  ? DashboardColors.danger
                                      .withValues(alpha: 0.07)
                                  : DashboardColors.surface,
                            ),
                            cells: [
                              DataCell(_DeletedAccountCell(record: record)),
                              DataCell(Text(record.phone)),
                              DataCell(Text(record.city)),
                              DataCell(DashboardBadge(
                                label: record.role,
                                color: record.role.contains('حرفي')
                                    ? DashboardColors.primary
                                    : DashboardColors.muted,
                              )),
                              DataCell(_ReasonCell(record: record)),
                              DataCell(Text(dashboardDate(record.deletedAt))),
                              DataCell(Text(record.deletedBy)),
                              DataCell(DashboardIconAction(
                                icon: Icons.info_outline,
                                tooltip: 'التفاصيل',
                                onPressed: () => _showDetails(record),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DashboardPagination(
                        summary:
                            'عرض 1 إلى ${records.take(10).length} من أصل ${records.length} سجل',
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 18),
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 300,
              child: _WarningCard(
                title: 'حالات الاشتباه',
                message:
                    'لا يحتوي المخطط الحالي على سبب حذف أو حقل اشتباه؛ يلزم جدول تدقيق مستقل لرصد الحالات الحساسة.',
                icon: Icons.warning_amber_rounded,
                color: DashboardColors.danger,
              ),
            ),
            SizedBox(
              width: 300,
              child: _WarningCard(
                title: 'التنظيف الآلي',
                message:
                    'لا توجد سياسة تنظيف محفوظة في قاعدة البيانات؛ هذه البطاقة معلوماتية فقط.',
                icon: Icons.cleaning_services,
                color: DashboardColors.primary,
              ),
            ),
            SizedBox(
              width: 300,
              child: _WarningCard(
                title: 'النسخ الاحتياطي',
                message:
                    'لا توجد مدة احتفاظ محفوظة في المخطط الحالي؛ يعرض الجدول آخر تحديث متاح من profiles.updated_at.',
                icon: Icons.save,
                color: DashboardColors.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDetails(DeletedAccountRecord record) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: DashboardColors.surfaceAlt,
            title: Text(record.accountName),
            content: Text(
              'الهاتف: ${record.phone}\n'
              'المدينة: ${record.city}\n'
              'سبب التعطيل: ${record.reason}\n'
              'المسؤول: ${record.deletedBy}\n'
              'آخر تحديث: ${dashboardDate(record.deletedAt)}',
              style: const TextStyle(height: 1.7),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _DeletedAccountCell extends StatelessWidget {
  const _DeletedAccountCell({required this.record});

  final DeletedAccountRecord record;

  @override
  Widget build(BuildContext context) {
    final shortId =
        record.id.length > 8 ? record.id.substring(0, 8) : record.id;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DashboardAvatar(
          label: record.accountName.substring(0, 1),
          color: record.isSuspicious
              ? DashboardColors.danger
              : DashboardColors.muted,
        ),
        const SizedBox(width: 9),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.accountName,
              style: const TextStyle(
                color: DashboardColors.text,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'ID: $shortId',
              style: const TextStyle(
                color: DashboardColors.muted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReasonCell extends StatelessWidget {
  const _ReasonCell({required this.record});

  final DeletedAccountRecord record;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Row(
        children: [
          if (record.isSuspicious) ...[
            const Icon(Icons.circle, color: DashboardColors.danger, size: 8),
            const SizedBox(width: 7),
          ],
          Expanded(
            child: Text(
              record.reason,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: dashboardPanelDecoration(
        color: color.withValues(alpha: 0.08),
      ).copyWith(
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    color: DashboardColors.muted,
                    fontSize: 12,
                    height: 1.5,
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
