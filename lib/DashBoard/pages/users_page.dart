import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_components.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key, required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  String _query = '';
  UserDashboardRole? _role;
  UserDashboardStatus? _status;

  @override
  Widget build(BuildContext context) {
    final users = widget.snapshot.users.where((user) {
      final q = _query.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          user.name.toLowerCase().contains(q) ||
          user.phone.toLowerCase().contains(q);
      final matchesRole = _role == null || user.role == _role;
      final matchesStatus = _status == null || user.status == _status;
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DashboardPanel(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DashboardResponsiveBox(
                preferredWidth: 340,
                minWidth: 220,
                child: DashboardSearchField(
                  hint: 'بحث بالاسم أو رقم الهاتف...',
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 170,
                child: DashboardSelect<UserDashboardRole?>(
                  value: _role,
                  items: const {
                    null: 'كل الأدوار',
                    UserDashboardRole.client: 'العملاء',
                    UserDashboardRole.craftsman: 'الحرفيون',
                    UserDashboardRole.admin: 'المديرون',
                  },
                  onChanged: (value) => setState(() => _role = value),
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 180,
                child: DashboardSelect<UserDashboardStatus?>(
                  value: _status,
                  items: const {
                    null: 'كل الحالات',
                    UserDashboardStatus.active: 'نشط',
                    UserDashboardStatus.suspended: 'غير نشط',
                  },
                  onChanged: (value) => setState(() => _status = value),
                ),
              ),
              DashboardIconAction(
                icon: Icons.refresh,
                tooltip: 'تحديث',
                onPressed: () => ref.invalidate(dashboardSnapshotProvider),
              ),
              DashboardButton(
                label: 'إضافة مستخدم',
                icon: Icons.add,
                onPressed: () => _showMessage(
                  'واجهة إضافة المستخدم متاحة كعنصر واجهة فقط، ولا يوجد تدفق إنشاء إداري في المخطط الحالي.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DashboardPanel(
          padding: EdgeInsets.zero,
          child: users.isEmpty
              ? const DashboardEmptyState(
                  title: 'لا توجد نتائج',
                  message: 'جرّب تغيير البحث أو الفلاتر الحالية.',
                )
              : Column(
                  children: [
                    DashboardTableFrame(
                      minWidth: 940,
                      child: DataTable(
                        headingRowColor:
                            WidgetStateProperty.all(DashboardColors.surfaceAlt),
                        dataRowColor:
                            WidgetStateProperty.all(DashboardColors.surface),
                        columnSpacing: 26,
                        columns: const [
                          DataColumn(label: Text('المستخدم')),
                          DataColumn(label: Text('الهاتف')),
                          DataColumn(label: Text('الدور')),
                          DataColumn(label: Text('الحالة')),
                          DataColumn(label: Text('المدينة')),
                          DataColumn(label: Text('آخر تحديث')),
                          DataColumn(label: Text('الإجراءات')),
                        ],
                        rows: users.take(10).map((user) {
                          final isActive =
                              user.status != UserDashboardStatus.suspended;
                          return DataRow(
                            cells: [
                              DataCell(_UserIdentityCell(user: user)),
                              DataCell(Text(user.phone)),
                              DataCell(
                                DashboardBadge(
                                  label: userRoleLabel(user.role),
                                  color: userRoleColor(user.role),
                                  icon: Icons.circle,
                                ),
                              ),
                              DataCell(
                                DashboardBadge(
                                  label: userStatusLabel(user.status),
                                  color: userStatusColor(user.status),
                                ),
                              ),
                              DataCell(Text(user.city ?? 'غير متوفر')),
                              DataCell(Text(user.lastSeenLabel)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DashboardIconAction(
                                      icon: Icons.visibility_outlined,
                                      tooltip: 'عرض',
                                      onPressed: () => _showDetails(user),
                                    ),
                                    const SizedBox(width: 6),
                                    DashboardIconAction(
                                      icon: isActive
                                          ? Icons.pause_circle_outline
                                          : Icons.play_circle_outline,
                                      tooltip:
                                          isActive ? 'تعطيل' : 'إعادة تفعيل',
                                      color: isActive
                                          ? DashboardColors.warning
                                          : DashboardColors.success,
                                      onPressed: () => _setUserActive(
                                        user,
                                        !isActive,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    DashboardIconAction(
                                      icon: Icons.delete_outline,
                                      tooltip: 'تعطيل آمن',
                                      color: DashboardColors.danger,
                                      onPressed: isActive
                                          ? () => _showDeleteDialog(user)
                                          : null,
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
                            'عرض 1 إلى ${users.take(10).length} من أصل ${users.length} مستخدم',
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> _setUserActive(DashboardUser user, bool isActive) async {
    try {
      await ref.read(dashboardAdminServiceProvider).setUserActive(
            userId: user.id,
            isActive: isActive,
          );
      ref.invalidate(dashboardSnapshotProvider);
      if (mounted) {
        _showMessage(isActive
            ? 'تمت إعادة تفعيل ${user.name}.'
            : 'تم تعطيل ${user.name} بشكل آمن.');
      }
    } catch (error) {
      if (mounted) _showMessage('تعذر تحديث حالة المستخدم: $error');
    }
  }

  void _showDeleteDialog(DashboardUser user) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: DashboardColors.surfaceAlt,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: DashboardColors.danger.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: DashboardColors.danger,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'تعطيل المستخدم',
                      style: TextStyle(
                        color: DashboardColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'هل أنت متأكد من تعطيل ${user.name}؟ سيتم تنفيذ حذف آمن بتحديث profiles.is_active إلى false بدون حذف حساب المصادقة.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: DashboardColors.muted,
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: DashboardButton(
                            label: 'تأكيد التعطيل',
                            icon: Icons.delete_outline,
                            color: DashboardColors.danger,
                            onPressed: () {
                              Navigator.of(context).pop();
                              _setUserActive(user, false);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DashboardButton(
                            label: 'إلغاء',
                            icon: Icons.close,
                            outlined: true,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetails(DashboardUser user) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: DashboardColors.surfaceAlt,
            title: Text(user.name),
            content: Text(
              'الدور: ${userRoleLabel(user.role)}\n'
              'الهاتف: ${user.phone}\n'
              'المدينة: ${user.city ?? 'غير متوفر'}\n'
              'التخصص: ${user.specialty ?? 'غير متوفر'}',
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

class _UserIdentityCell extends StatelessWidget {
  const _UserIdentityCell({required this.user});

  final DashboardUser user;

  @override
  Widget build(BuildContext context) {
    final shortId = user.id.length > 8 ? user.id.substring(0, 8) : user.id;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DashboardAvatar(
          label: user.initials,
          imageUrl: user.avatarUrl,
          color: userRoleColor(user.role),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
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
