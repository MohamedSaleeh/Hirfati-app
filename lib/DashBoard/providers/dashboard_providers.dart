import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FutureProvider, Provider;
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dashboard_models.dart';
import '../services/dashboard_admin_service.dart';

final dashboardSectionProvider = StateProvider<DashboardSection>(
  (ref) => DashboardSection.overview,
);

final dashboardAdminServiceProvider = Provider<DashboardAdminService>((ref) {
  return DashboardAdminService(Supabase.instance.client);
});

final dashboardAccessProvider = FutureProvider<bool>((ref) {
  return ref.watch(dashboardAdminServiceProvider).isCurrentUserAdmin();
});

final dashboardSnapshotProvider = FutureProvider<DashboardSnapshot>((ref) {
  return ref.watch(dashboardAdminServiceProvider).loadDashboard();
});

final dashboardNotificationSettingsProvider =
    FutureProvider<DashboardNotificationSettings>((ref) {
  return ref.watch(dashboardAdminServiceProvider).loadMyNotificationSettings();
});
