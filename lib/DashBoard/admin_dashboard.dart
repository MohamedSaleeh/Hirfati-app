import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/dashboard_models.dart';
import 'pages/complaints_page.dart';
import 'pages/deletions_page.dart';
import 'pages/overview_page.dart';
import 'pages/settings_page.dart';
import 'pages/users_page.dart';
import 'pages/verification_page.dart';
import 'providers/dashboard_providers.dart';
import 'theme/dashboard_colors.dart';
import 'widgets/dashboard_components.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_sidebar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: DashboardColors.background,
        colorScheme: const ColorScheme.dark(
          primary: DashboardColors.primary,
          surface: DashboardColors.surface,
          error: DashboardColors.danger,
        ),
      ),
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: DashboardShell(),
      ),
    );
  }
}

class DashboardShell extends ConsumerWidget {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(dashboardSectionProvider);
    final accessAsync = ref.watch(dashboardAccessProvider);

    return accessAsync.when(
      data: (hasAccess) {
        if (!hasAccess) return const _DashboardAccessDenied();

        final snapshotAsync = ref.watch(dashboardSnapshotProvider);
        return snapshotAsync.when(
          data: (snapshot) => _DashboardFrame(
            selectedSection: selectedSection,
            snapshot: snapshot,
            child: _sectionPage(selectedSection, snapshot),
          ),
          loading: () => _DashboardFrame(
            selectedSection: selectedSection,
            snapshot: DashboardSnapshot.empty,
            child: const Center(
              child: CircularProgressIndicator(color: DashboardColors.primary),
            ),
          ),
          error: (error, _) => _DashboardFrame(
            selectedSection: selectedSection,
            snapshot: DashboardSnapshot.empty,
            child: _DashboardError(
              error: error,
              onRetry: () => ref.invalidate(dashboardSnapshotProvider),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: DashboardColors.primary),
        ),
      ),
      error: (error, _) => _DashboardFrame(
        selectedSection: selectedSection,
        snapshot: DashboardSnapshot.empty,
        child: _DashboardError(
          error: error,
          onRetry: () => ref.invalidate(dashboardAccessProvider),
        ),
      ),
    );
  }

  Widget _sectionPage(DashboardSection section, DashboardSnapshot snapshot) {
    return switch (section) {
      DashboardSection.overview => OverviewPage(snapshot: snapshot),
      DashboardSection.users => UsersPage(snapshot: snapshot),
      DashboardSection.verification => VerificationPage(snapshot: snapshot),
      DashboardSection.complaints => ComplaintsPage(snapshot: snapshot),
      DashboardSection.deletions => DeletionsPage(snapshot: snapshot),
      DashboardSection.settings => const SettingsPage(),
    };
  }
}

class _DashboardFrame extends StatelessWidget {
  const _DashboardFrame({
    required this.selectedSection,
    required this.snapshot,
    required this.child,
  });

  final DashboardSection selectedSection;
  final DashboardSnapshot snapshot;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 1040;
          final sidebarWidth = isCompact ? 196.0 : 224.0;

          return Row(
            textDirection: TextDirection.ltr,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      DashboardHeader(section: selectedSection),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            isCompact ? 18 : 28,
                            18,
                            isCompact ? 18 : 28,
                            28,
                          ),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: sidebarWidth,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: DashboardSidebar(
                    selectedSection: selectedSection,
                    snapshot: snapshot,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: dashboardPanelDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: DashboardColors.danger,
              size: 34,
            ),
            const SizedBox(height: 12),
            const Text(
              'تعذر تحميل لوحة التحكم',
              style: TextStyle(
                color: DashboardColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DashboardColors.muted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardAccessDenied extends ConsumerWidget {
  const _DashboardAccessDenied();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 460,
          padding: const EdgeInsets.all(26),
          decoration: dashboardPanelDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: DashboardColors.danger.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: DashboardColors.danger,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'لا تملك صلاحية الوصول',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DashboardColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'هذه اللوحة متاحة فقط للحسابات التي تحمل دور مدير في جدول الملفات الشخصية.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DashboardColors.muted,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              DashboardButton(
                label: 'تسجيل الخروج',
                icon: Icons.logout,
                outlined: true,
                color: DashboardColors.danger,
                onPressed: () async {
                  await ref.read(dashboardAdminServiceProvider).signOut();
                  ref.invalidate(dashboardAccessProvider);
                  ref.invalidate(dashboardSnapshotProvider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
