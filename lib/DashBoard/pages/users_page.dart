import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/admin_users_models.dart';
import '../models/admin_wallet_deposit_models.dart';
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
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(adminUsersControllerProvider);
    final users = usersState.users;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final visibleRange = UserPagination.visibleRange(
      usersState.query.currentPage,
      usersState.query.pageSize,
      users.length,
      usersState.totalUsers,
    );

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
                  onChanged: (value) {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 350),
                      () {
                        if (!mounted) return;
                        ref
                            .read(adminUsersControllerProvider.notifier)
                            .setSearch(value);
                      },
                    );
                  },
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 170,
                child: DashboardSelect<UserDashboardRole?>(
                  value: usersState.query.role,
                  items: const {
                    null: 'كل الأدوار',
                    UserDashboardRole.client: 'العملاء',
                    UserDashboardRole.craftsman: 'الحرفيون',
                    UserDashboardRole.admin: 'المديرون',
                  },
                  onChanged: (value) => ref
                      .read(adminUsersControllerProvider.notifier)
                      .setRole(value),
                ),
              ),
              DashboardResponsiveBox(
                preferredWidth: 180,
                child: DashboardSelect<UserDashboardStatus?>(
                  value: usersState.query.status,
                  items: const {
                    null: 'كل الحالات',
                    UserDashboardStatus.active: 'نشط',
                    UserDashboardStatus.suspended: 'غير نشط',
                  },
                  onChanged: (value) => ref
                      .read(adminUsersControllerProvider.notifier)
                      .setStatus(value),
                ),
              ),
              DashboardIconAction(
                icon: Icons.refresh,
                tooltip: 'تحديث',
                onPressed: usersState.loading
                    ? null
                    : () => ref
                          .read(adminUsersControllerProvider.notifier)
                          .load(),
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
          child: usersState.loading && users.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: DashboardColors.primary,
                    ),
                  ),
                )
              : usersState.errorMessage != null && users.isEmpty
              ? DashboardEmptyState(
                  title: 'تعذر تحميل المستخدمين',
                  message: usersState.errorMessage!,
                  actionLabel: 'إعادة المحاولة',
                  onAction: () =>
                      ref.read(adminUsersControllerProvider.notifier).load(),
                )
              : users.isEmpty
              ? const DashboardEmptyState(
                  title: 'لا توجد نتائج',
                  message: 'جرّب تغيير البحث أو الفلاتر الحالية.',
                )
              : Column(
                  children: [
                    DashboardTableFrame(
                      minWidth: 940,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          DashboardColors.surfaceAlt,
                        ),
                        dataRowColor: WidgetStateProperty.all(
                          DashboardColors.surface,
                        ),
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
                        rows: users.map((user) {
                          final isActive =
                              user.status != UserDashboardStatus.suspended;
                          final isProcessing = usersState.processingUserIds
                              .contains(user.id);
                          final isCurrentAdmin = user.id == currentUserId;
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
                                      onPressed: isProcessing
                                          ? null
                                          : () => _showDetails(user),
                                    ),
                                    if (user.role == UserDashboardRole.client &&
                                        isActive) ...[
                                      const SizedBox(width: 6),
                                      DashboardIconAction(
                                        icon: Icons
                                            .account_balance_wallet_outlined,
                                        tooltip: 'إضافة رصيد',
                                        color: DashboardColors.success,
                                        onPressed: isProcessing
                                            ? null
                                            : () => _showWalletDepositDialog(
                                                user,
                                              ),
                                      ),
                                    ],
                                    const SizedBox(width: 6),
                                    DashboardIconAction(
                                      icon: isActive
                                          ? Icons.pause_circle_outline
                                          : Icons.play_circle_outline,
                                      tooltip: isActive
                                          ? 'تعطيل'
                                          : 'إعادة تفعيل',
                                      color: isActive
                                          ? DashboardColors.warning
                                          : DashboardColors.success,
                                      onPressed:
                                          isProcessing ||
                                              (isCurrentAdmin && isActive)
                                          ? null
                                          : () => _confirmStatusToggle(
                                              user,
                                              !isActive,
                                            ),
                                    ),
                                    const SizedBox(width: 6),
                                    DashboardIconAction(
                                      icon: Icons.delete_outline,
                                      tooltip: 'تعطيل آمن',
                                      color: DashboardColors.danger,
                                      onPressed:
                                          isActive &&
                                              !isProcessing &&
                                              !isCurrentAdmin
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
                            'عرض ${visibleRange.first} إلى ${visibleRange.last} من أصل ${usersState.totalUsers} مستخدم',
                        currentPage: usersState.query.currentPage,
                        totalPages: usersState.totalPages,
                        onPageChanged: (page) => ref
                            .read(adminUsersControllerProvider.notifier)
                            .goToPage(page),
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
      final changed = await ref
          .read(adminUsersControllerProvider.notifier)
          .setActiveStatus(user.id, isActive);
      if (!changed) return;
      ref.invalidate(dashboardOverviewProvider);
      ref.invalidate(dashboardSnapshotProvider);
      if (mounted) {
        _showMessage(
          isActive
              ? 'تمت إعادة تفعيل ${user.name}.'
              : 'تم تعطيل ${user.name} بشكل آمن.',
        );
      }
    } on AdminUsersActionException catch (error) {
      if (mounted) _showMessage(error.message);
    }
  }

  Future<void> _confirmStatusToggle(DashboardUser user, bool isActive) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isActive ? 'إعادة تفعيل الحساب' : 'تعطيل الحساب'),
        content: Text(
          isActive
              ? 'هل تريد إعادة تفعيل حساب ${user.name}؟'
              : 'هل تريد تعطيل حساب ${user.name}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(isActive ? 'تفعيل' : 'تعطيل'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _setUserActive(user, isActive);
  }

  Future<void> _showWalletDepositDialog(DashboardUser user) async {
    final amountController = TextEditingController();
    final referenceController = TextEditingController();
    final noteController = TextEditingController();
    final idempotencyKey = _newIdempotencyKey();
    final balanceFuture = ref
        .read(adminWalletDepositControllerProvider.notifier)
        .getBalance(user.id);
    var submitting = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة رصيد'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('العميل: ${user.name}'),
                  SelectableText('المعرف: ${user.id}'),
                  FutureBuilder<double>(
                    future: balanceFuture,
                    builder: (context, snapshot) => Text(
                      snapshot.hasData
                          ? 'الرصيد الحالي: \$${snapshot.data!.toStringAsFixed(0)} USD'
                          : 'الرصيد الحالي: جارٍ التحميل...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    enabled: !submitting,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'مبلغ الشحن *',
                      suffixText: 'USD',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: referenceController,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      labelText: 'مرجع الدفع الخارجي *',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    enabled: !submitting,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'ملاحظة إدارية (اختياري)',
                    ),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorText!,
                      style: const TextStyle(color: DashboardColors.danger),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      final amount = double.tryParse(
                        amountController.text.replaceAll(',', '').trim(),
                      );
                      final request = AdminWalletDepositRequest(
                        userId: user.id,
                        amount: amount ?? 0,
                        reference: referenceController.text,
                        note: noteController.text,
                        idempotencyKey: idempotencyKey,
                      );
                      final validation = request.validate();
                      if (validation != null) {
                        setDialogState(
                          () => errorText = _walletDepositError(validation),
                        );
                        return;
                      }
                      setDialogState(() {
                        submitting = true;
                        errorText = null;
                      });
                      try {
                        final result = await ref
                            .read(adminWalletDepositControllerProvider.notifier)
                            .deposit(request);
                        if (result == null || !dialogContext.mounted) return;
                        Navigator.pop(dialogContext);
                        if (mounted) {
                          _showMessage(
                            'تمت إضافة الرصيد بنجاح. الرصيد الجديد: '
                            '\$${result.balanceAfter.toStringAsFixed(0)} USD',
                          );
                        }
                      } on AdminWalletDepositException catch (error) {
                        if (dialogContext.mounted) {
                          setDialogState(() {
                            submitting = false;
                            errorText = _walletDepositError(error.code);
                          });
                        }
                      } catch (_) {
                        if (dialogContext.mounted) {
                          setDialogState(() {
                            submitting = false;
                            errorText = _walletDepositError('unexpected');
                          });
                        }
                      }
                    },
              child: submitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('تأكيد الإضافة'),
            ),
          ],
        ),
      ),
    );

    amountController.dispose();
    referenceController.dispose();
    noteController.dispose();
  }

  String _newIdempotencyKey() {
    final random = Random.secure();
    String hex(int length) => List.generate(
      length,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    return '${hex(8)}-${hex(4)}-4${hex(3)}-a${hex(3)}-${hex(12)}';
  }

  String _walletDepositError(String code) {
    return switch (code) {
      'unauthenticated' => 'انتهت جلسة الدخول. يرجى تسجيل الدخول مجددًا.',
      'forbidden' => 'ليست لديك صلاحية لإضافة الرصيد.',
      'target_user_not_found' => 'تعذر العثور على حساب العميل.',
      'target_must_be_client' => 'يمكن إضافة الرصيد لحسابات العملاء فقط.',
      'inactive_target_account' => 'لا يمكن شحن حساب غير نشط.',
      'invalid_deposit_amount' => 'أدخل مبلغًا رقميًا أكبر من صفر.',
      'missing_external_reference' => 'مرجع الدفع الخارجي مطلوب.',
      'missing_idempotency_key' => 'تعذر إنشاء معرف العملية. أعد فتح النافذة.',
      'wallet_locked' => 'محفظة العميل مقفلة حاليًا.',
      'idempotency_conflict' => 'تعارض في معرف العملية. أعد فتح النافذة.',
      _ => 'تعذر إضافة الرصيد. حاول مرة أخرى.',
    };
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
