import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_components.dart';

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  String _query = '';
  String _specialty = 'all';
  String _sort = 'newest';

  @override
  Widget build(BuildContext context) {
    final specialties = {
      'all': 'جميع التخصصات',
      for (final request in widget.snapshot.verificationRequests)
        request.specialty: request.specialty,
    };
    final requests = widget.snapshot.verificationRequests.where((request) {
      final q = _query.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          request.craftsmanName.toLowerCase().contains(q) ||
          request.phone.toLowerCase().contains(q) ||
          request.city.toLowerCase().contains(q) ||
          request.specialty.toLowerCase().contains(q);
      final matchesSpecialty =
          _specialty == 'all' || request.specialty == _specialty;
      return matchesSearch && matchesSpecialty;
    }).toList()
      ..sort((a, b) {
        final aDate = a.requestedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.requestedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return _sort == 'newest'
            ? bDate.compareTo(aDate)
            : aDate.compareTo(bDate);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            DashboardButton(
              label: 'تصدير',
              icon: Icons.download,
              outlined: true,
              onPressed: () => _showMessage(
                'تصدير CSV غير متاح حالياً بدون خدمة تنزيل مخصصة للويب.',
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 16),
        DashboardPanel(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DashboardResponsiveBox(
                preferredWidth: 420,
                minWidth: 240,
                child: DashboardSearchField(
                  hint: 'ابحث بالاسم، الهاتف، المدينة، أو التخصص...',
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 220,
                child: DashboardSelect<String>(
                  value: _specialty,
                  items: specialties,
                  onChanged: (value) {
                    if (value != null) setState(() => _specialty = value);
                  },
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 190,
                child: DashboardSelect<String>(
                  value: _sort,
                  items: const {
                    'newest': 'الأحدث أولاً',
                    'oldest': 'الأقدم أولاً',
                  },
                  onChanged: (value) {
                    if (value != null) setState(() => _sort = value);
                  },
                ),
              ),
              DashboardIconAction(
                icon: Icons.refresh,
                tooltip: 'تحديث',
                onPressed: () => ref.invalidate(dashboardSnapshotProvider),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DashboardPanel(
          padding: EdgeInsets.zero,
          child: requests.isEmpty
              ? const DashboardEmptyState(
                  title: 'لا توجد طلبات توثيق',
                  message:
                      'ستظهر هنا صفوف workers التي اكتمل ملفها ولم تتم الموافقة عليها.',
                )
              : Column(
                  children: [
                    DashboardTableFrame(
                      minWidth: 1120,
                      child: DataTable(
                        headingRowColor:
                            WidgetStateProperty.all(DashboardColors.surfaceAlt),
                        dataRowColor:
                            WidgetStateProperty.all(DashboardColors.surface),
                        columnSpacing: 26,
                        columns: const [
                          DataColumn(label: Text('المعرف')),
                          DataColumn(label: Text('الحرفي')),
                          DataColumn(label: Text('التخصص')),
                          DataColumn(label: Text('المدينة')),
                          DataColumn(label: Text('الخبرة')),
                          DataColumn(label: Text('التقييم')),
                          DataColumn(label: Text('تاريخ الطلب')),
                          DataColumn(label: Text('المرفقات')),
                          DataColumn(label: Text('الإجراءات')),
                        ],
                        rows: requests.take(10).map((request) {
                          final rejected = request.status ==
                              VerificationDashboardStatus.rejected;
                          return DataRow(
                            color: WidgetStateProperty.all(
                              rejected
                                  ? DashboardColors.danger
                                      .withValues(alpha: 0.09)
                                  : DashboardColors.surface,
                            ),
                            cells: [
                              DataCell(Text('#${_shortId(request.id)}')),
                              DataCell(_VerificationUserCell(request: request)),
                              DataCell(DashboardBadge(
                                label: request.specialty,
                                color: DashboardColors.primary,
                              )),
                              DataCell(Text(request.city)),
                              DataCell(Text(_experienceLabel(request))),
                              DataCell(Text(_ratingLabel(request))),
                              DataCell(
                                Text(dashboardDate(request.requestedAt)),
                              ),
                              const DataCell(
                                Text(
                                  'غير متوفرة',
                                  style: TextStyle(
                                    color: DashboardColors.muted,
                                  ),
                                ),
                              ),
                              DataCell(_VerificationActions(
                                request: request,
                                onAccept: () => _updateStatus(
                                  request,
                                  VerificationDashboardStatus.approved,
                                ),
                                onReject: () => _updateStatus(
                                  request,
                                  VerificationDashboardStatus.rejected,
                                ),
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
                            'عرض 1 إلى ${requests.take(10).length} من أصل ${requests.length} نتيجة',
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> _updateStatus(
    DashboardVerificationRequest request,
    VerificationDashboardStatus status,
  ) async {
    try {
      await ref.read(dashboardAdminServiceProvider).updateVerificationStatus(
            request: request,
            status: status,
          );
      ref.invalidate(dashboardSnapshotProvider);
      if (mounted) {
        _showMessage(status == VerificationDashboardStatus.approved
            ? 'تم قبول توثيق ${request.craftsmanName}.'
            : 'تم رفض الطلب، ولا يوجد حقل لحفظ سبب الرفض في المخطط الحالي.');
      }
    } catch (error) {
      if (mounted) _showMessage('تعذر تحديث حالة الطلب: $error');
    }
  }

  String _shortId(String id) => id.length > 8 ? id.substring(0, 8) : id;

  String _experienceLabel(DashboardVerificationRequest request) {
    final years = request.experienceYears;
    if (years == null) return 'غير متوفر';
    return '$years سنوات';
  }

  String _ratingLabel(DashboardVerificationRequest request) {
    final rating = request.ratingAverage;
    if (rating == null) return 'لا يوجد';
    return rating.toStringAsFixed(1);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _VerificationUserCell extends StatelessWidget {
  const _VerificationUserCell({required this.request});

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

class _VerificationActions extends StatelessWidget {
  const _VerificationActions({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  final DashboardVerificationRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    if (request.status == VerificationDashboardStatus.rejected) {
      return const DashboardBadge(
        label: 'تم الرفض',
        color: DashboardColors.danger,
        icon: Icons.block,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DashboardButton(
          label: 'قبول',
          icon: Icons.check,
          onPressed: request.status == VerificationDashboardStatus.approved
              ? null
              : onAccept,
        ),
        const SizedBox(width: 8),
        DashboardButton(
          label: 'رفض',
          icon: Icons.close,
          color: DashboardColors.danger,
          outlined: true,
          onPressed: onReject,
        ),
      ],
    );
  }
}
