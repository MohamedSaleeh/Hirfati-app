import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_components.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth >= 1120
                ? (constraints.maxWidth - 48) / 4
                : constraints.maxWidth >= 680
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: 164,
                  child: DashboardStatCard(
                    title: 'إجمالي المستخدمين',
                    value: dashboardNumber(snapshot.totalUsers),
                    icon: Icons.groups,
                    color: DashboardColors.primary,
                    subtitle: 'المسجلون في profiles',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: 164,
                  child: DashboardStatCard(
                    title: 'إجمالي الحرفيين',
                    value: dashboardNumber(snapshot.metrics.totalWorkers),
                    icon: Icons.engineering,
                    color: DashboardColors.primary,
                    subtitle: 'المسجلون في workers',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: 164,
                  child: DashboardStatCard(
                    title: 'إجمالي الطلبات',
                    value: dashboardNumber(snapshot.metrics.totalOrders),
                    icon: Icons.receipt_long,
                    color: DashboardColors.warning,
                    subtitle:
                        'اليوم ${dashboardNumber(snapshot.metrics.ordersToday)} / مكتملة ${dashboardNumber(snapshot.metrics.completedOrders)}',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: 164,
                  child: DashboardStatCard(
                    title: 'الطلبات النشطة',
                    value: dashboardNumber(snapshot.metrics.activeOrders),
                    icon: Icons.pending_actions,
                    color: DashboardColors.primary,
                    subtitle: 'معلقة، مقبولة، أو قيد التنفيذ',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        _MetricsPanel(metrics: snapshot.metrics),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 980;
            final table = PendingVerificationPanel(snapshot: snapshot);
            final side = Column(
              children: [
                UrgentComplaintsPanel(snapshot: snapshot),
                const SizedBox(height: 16),
                RecentActivityPanel(snapshot: snapshot),
              ],
            );

            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [side, const SizedBox(height: 16), table],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: table),
                const SizedBox(width: 18),
                Expanded(flex: 4, child: side),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        _RankedLists(snapshot: snapshot),
      ],
    );
  }
}

class _MetricsPanel extends StatelessWidget {
  const _MetricsPanel({required this.metrics});

  final DashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final values = <(String, String)>[
      ('المدفوعات المكتملة', dashboardAmount(metrics.completedPaymentsAmount)),
      (
        'السحوبات المكتملة',
        dashboardAmount(metrics.completedWithdrawalsAmount),
      ),
      ('إجمالي أرصدة المحافظ', dashboardAmount(metrics.totalWalletBalance)),
      (
        'طلبات التوثيق المعلقة',
        dashboardNumber(metrics.pendingVerificationRequests),
      ),
      (
        'رسائل الدعم غير المحلولة',
        dashboardNumber(metrics.unresolvedSupportMessages),
      ),
      ('إجمالي الإشعارات', dashboardNumber(metrics.totalNotifications)),
    ];
    return DashboardPanel(
      title: 'المؤشرات المالية والتشغيلية',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: values
            .map(
              (value) => SizedBox(
                width: 220,
                child: ListTile(
                  dense: true,
                  title: Text(
                    value.$1,
                    style: const TextStyle(color: DashboardColors.muted),
                  ),
                  subtitle: Text(
                    value.$2,
                    style: const TextStyle(
                      color: DashboardColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RankedLists extends StatelessWidget {
  const _RankedLists({required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panels = [
          DashboardPanel(
            title: 'أحدث المستخدمين',
            child: snapshot.latestUsers.isEmpty
                ? const DashboardEmptyState(
                    title: 'لا يوجد مستخدمون',
                    message: 'ستظهر أحدث الحسابات هنا.',
                  )
                : Column(
                    children: snapshot.latestUsers
                        .map(
                          (user) => _SimpleRow(
                            title: user.name,
                            subtitle: user.city ?? _roleText(user.role),
                            value: dashboardDate(user.createdAt),
                          ),
                        )
                        .toList(),
                  ),
          ),
          DashboardPanel(
            title: 'أفضل الحرفيين',
            child: snapshot.topWorkers.isEmpty
                ? const DashboardEmptyState(
                    title: 'لا يوجد حرفيون',
                    message: 'ستظهر تقييمات الحرفيين هنا.',
                  )
                : Column(
                    children: snapshot.topWorkers
                        .map(
                          (worker) => _SimpleRow(
                            title: worker.fullName,
                            subtitle: worker.approved ? 'معتمد' : 'غير معتمد',
                            value:
                                '${worker.ratingAverage.toStringAsFixed(1)} (${worker.ratingCount})',
                          ),
                        )
                        .toList(),
                  ),
          ),
          DashboardPanel(
            title: 'أكثر التصنيفات طلباً',
            child: snapshot.topCategories.isEmpty
                ? const DashboardEmptyState(
                    title: 'لا توجد تصنيفات',
                    message: 'ستظهر التصنيفات المرتبطة بالطلبات هنا.',
                  )
                : Column(
                    children: snapshot.topCategories
                        .map(
                          (category) => _SimpleRow(
                            title: category.name,
                            subtitle: 'عدد الطلبات',
                            value: dashboardNumber(category.orderCount),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ];
        if (constraints.maxWidth < 980) {
          return Column(
            children: panels
                .expand((panel) => [panel, const SizedBox(height: 14)])
                .toList(),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              panels
                  .expand(
                    (panel) => [
                      Expanded(child: panel),
                      const SizedBox(width: 14),
                    ],
                  )
                  .toList()
                ..removeLast(),
        );
      },
    );
  }

  String _roleText(UserDashboardRole role) => switch (role) {
    UserDashboardRole.admin => 'مدير',
    UserDashboardRole.craftsman => 'حرفي',
    UserDashboardRole.client => 'عميل',
  };
}

class _SimpleRow extends StatelessWidget {
  const _SimpleRow({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String title;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, overflow: TextOverflow.ellipsis),
      trailing: Text(
        value,
        style: const TextStyle(
          color: DashboardColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class UrgentComplaintsPanel extends StatelessWidget {
  const UrgentComplaintsPanel({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final complaints = snapshot.urgentComplaints;

    return DashboardPanel(
      title: 'شكاوى عاجلة',
      trailing: const Icon(
        Icons.priority_high,
        color: DashboardColors.danger,
        size: 18,
      ),
      child: complaints.isEmpty
          ? const DashboardEmptyState(
              title: 'لا توجد شكاوى عاجلة',
              message: 'ستظهر هنا الشكاوى المفتوحة ذات الأولوية العالية.',
            )
          : Column(
              children: complaints.map((complaint) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DashboardColors.danger.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: DashboardColors.danger.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: DashboardColors.danger,
                            size: 8,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              complaint.subject,
                              style: const TextStyle(
                                color: DashboardColors.text,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        complaint.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: DashboardColors.muted,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class RecentActivityPanel extends StatelessWidget {
  const RecentActivityPanel({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      title: 'النشاط الأخير',
      child: snapshot.activityItems.isEmpty
          ? const DashboardEmptyState(
              title: 'لا يوجد نشاط بعد',
              message: 'سيتم عرض أحدث العمليات الموجودة في قاعدة البيانات هنا.',
            )
          : Column(
              children: snapshot.activityItems.map((item) {
                final color = activityToneColor(item.tone);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 9,
                          width: 9,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          height: 42,
                          width: 1,
                          color: DashboardColors.border,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dashboardTimeAgo(item.createdAt),
                              style: const TextStyle(
                                color: DashboardColors.muted,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: DashboardColors.text,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.description,
                              style: const TextStyle(
                                color: DashboardColors.muted,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
    );
  }
}

class PendingVerificationPanel extends ConsumerWidget {
  const PendingVerificationPanel({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = snapshot.verificationRequests
        .where(
          (request) => request.status == VerificationDashboardStatus.pending,
        )
        .take(5)
        .toList();

    return DashboardPanel(
      title: 'طلبات التوثيق المعلقة',
      trailing: TextButton(
        onPressed: () {
          ref.read(dashboardSectionProvider.notifier).state =
              DashboardSection.verification;
        },
        child: const Text('عرض الكل'),
      ),
      padding: EdgeInsets.zero,
      child: requests.isEmpty
          ? const DashboardEmptyState(
              title: 'لا توجد طلبات معلقة',
              message: 'طلبات توثيق الحرفيين المكتملة ستظهر في هذا الجدول.',
            )
          : DashboardTableFrame(
              minWidth: 840,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  DashboardColors.surfaceAlt,
                ),
                dataRowColor: WidgetStateProperty.all(DashboardColors.surface),
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('الحرفي')),
                  DataColumn(label: Text('المهنة')),
                  DataColumn(label: Text('المدينة')),
                  DataColumn(label: Text('تاريخ الطلب')),
                  DataColumn(label: Text('المستندات')),
                  DataColumn(label: Text('الإجراء')),
                ],
                rows: requests.map((request) {
                  return DataRow(
                    cells: [
                      DataCell(_CraftsmanCell(request: request)),
                      DataCell(Text(request.specialty)),
                      DataCell(Text(request.city)),
                      DataCell(Text(dashboardDate(request.requestedAt))),
                      const DataCell(
                        Text(
                          'غير متوفرة',
                          style: TextStyle(color: DashboardColors.muted),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DashboardIconAction(
                              icon: Icons.check,
                              tooltip: 'قبول',
                              color: DashboardColors.success,
                              onPressed: () => _updateStatus(
                                context,
                                ref,
                                request,
                                VerificationDashboardStatus.approved,
                              ),
                            ),
                            const SizedBox(width: 6),
                            DashboardIconAction(
                              icon: Icons.close,
                              tooltip: 'رفض',
                              color: DashboardColors.danger,
                              onPressed: () => _updateStatus(
                                context,
                                ref,
                                request,
                                VerificationDashboardStatus.rejected,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    DashboardVerificationRequest request,
    VerificationDashboardStatus status,
  ) async {
    try {
      await ref
          .read(dashboardAdminServiceProvider)
          .updateVerificationStatus(request: request, status: status);
      ref.invalidate(dashboardSnapshotProvider);
      if (context.mounted) {
        final message = status == VerificationDashboardStatus.approved
            ? 'تم قبول توثيق ${request.craftsmanName}.'
            : 'تم رفض الطلب، ولا يوجد حقل لحفظ سبب الرفض في المخطط الحالي.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تعذر تحديث الطلب: $error')));
      }
    }
  }
}

class _CraftsmanCell extends StatelessWidget {
  const _CraftsmanCell({required this.request});

  final DashboardVerificationRequest request;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DashboardAvatar(label: request.craftsmanName.substring(0, 1)),
        const SizedBox(width: 9),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.craftsmanName,
              style: const TextStyle(
                color: DashboardColors.text,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              request.phone,
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
