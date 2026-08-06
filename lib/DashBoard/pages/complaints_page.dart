import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_components.dart';

class ComplaintsPage extends ConsumerStatefulWidget {
  const ComplaintsPage({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  ConsumerState<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends ConsumerState<ComplaintsPage> {
  String _query = '';
  ComplaintDashboardStatus? _status;
  ComplaintPriority? _priority;

  @override
  Widget build(BuildContext context) {
    final complaints = widget.snapshot.complaints.where((complaint) {
      final q = _query.trim().toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          complaint.subject.toLowerCase().contains(q) ||
          complaint.message.toLowerCase().contains(q) ||
          complaint.complainantName.toLowerCase().contains(q);
      final matchesStatus = _status == null || complaint.status == _status;
      final matchesPriority =
          _priority == null || complaint.priority == _priority;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();

    final highCount = widget.snapshot.complaints
        .where(
          (complaint) =>
              complaint.priority == ComplaintPriority.high &&
              complaint.status != ComplaintDashboardStatus.archived,
        )
        .length;
    final resolvedCount = widget.snapshot.complaints
        .where(
          (complaint) => complaint.status == ComplaintDashboardStatus.archived,
        )
        .length;
    final weekCount = widget.snapshot.complaints.where((complaint) {
      final date = complaint.createdAt;
      return date != null && DateTime.now().difference(date).inDays <= 7;
    }).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 220,
              height: 150,
              child: DashboardStatCard(
                title: 'الشكاوى المفتوحة',
                value: dashboardNumber(widget.snapshot.openComplaintsCount),
                icon: Icons.folder_open,
                color: DashboardColors.primary,
              ),
            ),
            SizedBox(
              width: 220,
              height: 150,
              child: DashboardStatCard(
                title: 'عالية الأولوية',
                value: dashboardNumber(highCount),
                icon: Icons.priority_high,
                color: DashboardColors.danger,
                subtitle: 'تقدير بصري من النص فقط',
              ),
            ),
            SizedBox(
              width: 220,
              height: 150,
              child: DashboardStatCard(
                title: 'تم حلها',
                value: dashboardNumber(resolvedCount),
                icon: Icons.check_circle,
                color: DashboardColors.success,
              ),
            ),
            SizedBox(
              width: 220,
              height: 150,
              child: DashboardStatCard(
                title: 'آخر 7 أيام',
                value: dashboardNumber(weekCount),
                icon: Icons.timer,
                color: DashboardColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DashboardPanel(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DashboardResponsiveBox(
                preferredWidth: 340,
                minWidth: 220,
                child: DashboardSearchField(
                  hint: 'بحث في الشكاوى...',
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 180,
                child: DashboardSelect<ComplaintDashboardStatus?>(
                  value: _status,
                  items: const {
                    null: 'جميع الحالات',
                    ComplaintDashboardStatus.open: 'مفتوحة',
                    ComplaintDashboardStatus.archived: 'تم الحل',
                  },
                  onChanged: (value) => setState(() => _status = value),
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 200,
                child: DashboardSelect<ComplaintPriority?>(
                  value: _priority,
                  items: const {
                    null: 'كل الأولويات التقديرية',
                    ComplaintPriority.high: 'عالية',
                    ComplaintPriority.medium: 'متوسطة',
                    ComplaintPriority.low: 'منخفضة',
                  },
                  onChanged: (value) => setState(() => _priority = value),
                ),
              ),
              DashboardButton(
                label: 'تصفية',
                icon: Icons.filter_list,
                onPressed: null,
              ),
              DashboardIconAction(
                icon: Icons.refresh,
                tooltip: 'تحديث',
                onPressed: () => ref.invalidate(dashboardSnapshotProvider),
              ),
              DashboardIconAction(
                icon: Icons.download,
                tooltip: 'تصدير',
                onPressed: () => _showMessage('تصدير CSV غير متاح حالياً.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DashboardPanel(
          padding: EdgeInsets.zero,
          child: complaints.isEmpty
              ? const DashboardEmptyState(
                  title: 'لا توجد شكاوى',
                  message: 'لا توجد نتائج مطابقة للفلاتر الحالية.',
                )
              : Column(
                  children: [
                    DashboardTableFrame(
                      minWidth: 980,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          DashboardColors.surfaceAlt,
                        ),
                        dataRowColor: WidgetStateProperty.all(
                          DashboardColors.surface,
                        ),
                        columnSpacing: 26,
                        columns: const [
                          DataColumn(label: Text('رقم الشكوى')),
                          DataColumn(label: Text('المبلّغ')),
                          DataColumn(label: Text('الموضوع')),
                          DataColumn(label: Text('تاريخ التقديم')),
                          DataColumn(label: Text('الأولوية')),
                          DataColumn(label: Text('الحالة')),
                          DataColumn(label: Text('الإجراءات')),
                        ],
                        rows: complaints.take(10).map((complaint) {
                          final isResolved =
                              complaint.status ==
                              ComplaintDashboardStatus.archived;
                          return DataRow(
                            cells: [
                              DataCell(Text('#${_shortId(complaint.id)}')),
                              DataCell(_ComplainantCell(complaint: complaint)),
                              DataCell(_SubjectCell(complaint: complaint)),
                              DataCell(
                                Text(dashboardDate(complaint.createdAt)),
                              ),
                              DataCell(
                                DashboardBadge(
                                  label: complaintPriorityLabel(
                                    complaint.priority,
                                  ),
                                  color: complaintPriorityColor(
                                    complaint.priority,
                                  ),
                                ),
                              ),
                              DataCell(
                                DashboardBadge(
                                  label: complaintStatusLabel(complaint.status),
                                  color: complaintStatusColor(complaint.status),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DashboardButton(
                                      label: 'عرض التفاصيل',
                                      icon: Icons.visibility_outlined,
                                      outlined: true,
                                      onPressed: () => _showDetails(complaint),
                                    ),
                                    const SizedBox(width: 8),
                                    DashboardIconAction(
                                      icon: isResolved
                                          ? Icons.undo
                                          : Icons.check_circle_outline,
                                      tooltip: isResolved
                                          ? 'إعادة فتح'
                                          : 'وضع كمحلولة',
                                      color: isResolved
                                          ? DashboardColors.warning
                                          : DashboardColors.success,
                                      onPressed: () =>
                                          _toggleComplaintResolved(complaint),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DashboardPagination(
                        summary:
                            'عرض 1 إلى ${complaints.take(10).length} من أصل ${complaints.length} شكوى',
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> _toggleComplaintResolved(DashboardComplaint complaint) async {
    final isResolved = complaint.status == ComplaintDashboardStatus.archived;
    try {
      await ref
          .read(dashboardAdminServiceProvider)
          .setComplaintResolved(
            complaintId: complaint.id,
            isResolved: !isResolved,
          );
      ref.invalidate(dashboardSnapshotProvider);
      if (mounted) {
        _showMessage(isResolved ? 'تمت إعادة فتح الشكوى.' : 'تم حل الشكوى.');
      }
    } catch (error) {
      if (mounted) _showMessage('تعذر تحديث الشكوى: $error');
    }
  }

  void _showDetails(DashboardComplaint complaint) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: DashboardColors.surfaceAlt,
            title: Text(complaint.subject),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('المبلّغ: ${complaint.complainantName}'),
                  const SizedBox(height: 10),
                  Text(
                    complaint.message.isEmpty
                        ? 'لا توجد تفاصيل إضافية.'
                        : complaint.message,
                    style: const TextStyle(
                      color: DashboardColors.muted,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
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

  String _shortId(String id) => id.length > 8 ? id.substring(0, 8) : id;

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ComplainantCell extends StatelessWidget {
  const _ComplainantCell({required this.complaint});

  final DashboardComplaint complaint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DashboardAvatar(label: complaint.complainantName.substring(0, 1)),
        const SizedBox(width: 9),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint.complainantName,
              style: const TextStyle(
                color: DashboardColors.text,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              complaint.complainantRole,
              style: const TextStyle(
                color: DashboardColors.muted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubjectCell extends StatelessWidget {
  const _SubjectCell({required this.complaint});

  final DashboardComplaint complaint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            complaint.subject,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DashboardColors.text,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            complaint.message,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: DashboardColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
