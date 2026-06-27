import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/dashboard_colors.dart';
import 'dashboard_components.dart';

class DashboardSidebar extends ConsumerWidget {
  const DashboardSidebar({
    super.key,
    required this.selectedSection,
    required this.snapshot,
  });

  final DashboardSection selectedSection;
  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(dashboardAdminServiceProvider);
    final admin = _currentAdmin(service.currentUserId);
    final adminName = admin?.name ?? 'مدير النظام';
    final adminSubtitle =
        service.currentUserEmail ?? admin?.phone ?? 'حساب إداري';

    return Container(
      decoration: const BoxDecoration(
        color: DashboardColors.sidebar,
        border: Border(
          left: BorderSide(color: DashboardColors.border),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: DashboardColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.handyman,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'حرفتي أدمن',
                    style: TextStyle(
                      color: DashboardColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _SidebarGroup(
            label: 'الرئيسية',
            children: [
              _SidebarItem(
                label: 'لوحة التحكم',
                icon: Icons.dashboard_rounded,
                selected: selectedSection == DashboardSection.overview,
                onTap: () => _setSection(ref, DashboardSection.overview),
              ),
            ],
          ),
          _SidebarGroup(
            label: 'الإدارة',
            children: [
              _SidebarItem(
                label: 'إدارة المستخدمين',
                icon: Icons.group,
                selected: selectedSection == DashboardSection.users,
                onTap: () => _setSection(ref, DashboardSection.users),
              ),
              _SidebarItem(
                label: 'توثيق الحرفيين',
                icon: Icons.verified_user,
                badge: snapshot.pendingVerificationCount.toString(),
                selected: selectedSection == DashboardSection.verification,
                onTap: () => _setSection(ref, DashboardSection.verification),
              ),
              _SidebarItem(
                label: 'الشكاوى والنزاعات',
                icon: Icons.warning_amber_rounded,
                badge: snapshot.openComplaintsCount.toString(),
                badgeColor: DashboardColors.danger,
                selected: selectedSection == DashboardSection.complaints,
                onTap: () => _setSection(ref, DashboardSection.complaints),
              ),
            ],
          ),
          _SidebarGroup(
            label: 'النظام',
            children: [
              _SidebarItem(
                label: 'سجل المحذوفات',
                icon: Icons.delete_outline,
                selected: selectedSection == DashboardSection.deletions,
                onTap: () => _setSection(ref, DashboardSection.deletions),
              ),
              _SidebarItem(
                label: 'الإعدادات',
                icon: Icons.settings,
                selected: selectedSection == DashboardSection.settings,
                onTap: () => _setSection(ref, DashboardSection.settings),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                DashboardAvatar(
                  label: admin?.initials ?? 'مد',
                  imageUrl: admin?.avatarUrl,
                  color: DashboardColors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adminName,
                        style: const TextStyle(
                          color: DashboardColors.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        adminSubtitle,
                        style: const TextStyle(
                          color: DashboardColors.muted,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Tooltip(
                  message: 'تسجيل الخروج',
                  child: IconButton(
                    onPressed: () async {
                      await service.signOut();
                      ref.invalidate(dashboardAccessProvider);
                      ref.invalidate(dashboardSnapshotProvider);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: DashboardColors.muted,
                      size: 18,
                    ),
                    splashRadius: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DashboardUser? _currentAdmin(String? currentUserId) {
    if (currentUserId == null) return null;
    for (final user in snapshot.users) {
      if (user.id == currentUserId) return user;
    }
    return null;
  }

  void _setSection(WidgetRef ref, DashboardSection section) {
    ref.read(dashboardSectionProvider.notifier).state = section;
  }
}

class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              label,
              style: const TextStyle(
                color: DashboardColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badge,
    this.badgeColor = DashboardColors.primary,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? DashboardColors.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color:
                    selected ? DashboardColors.primary : DashboardColors.muted,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? DashboardColors.primary
                        : DashboardColors.muted,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badge != null && badge != '0')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
