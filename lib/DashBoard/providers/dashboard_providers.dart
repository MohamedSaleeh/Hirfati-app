import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FutureProvider, Provider;
import 'package:flutter_riverpod/legacy.dart'
    show StateNotifier, StateNotifierProvider, StateProvider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dashboard_models.dart';
import '../models/admin_users_models.dart';
import '../models/admin_wallet_deposit_models.dart';
import '../data/datasources/admin_verification_datasource.dart';
import '../data/datasources/admin_users_datasource.dart';
import '../data/datasources/admin_wallet_deposit_datasource.dart';
import '../data/datasources/dashboard_supabase_datasource.dart';
import '../data/repositories/admin_verification_repository_impl.dart';
import '../data/repositories/admin_users_repository_impl.dart';
import '../data/repositories/admin_wallet_deposit_repository_impl.dart';
import '../data/repositories/dashboard_repository_impl.dart';
import '../domain/repositories/admin_verification_repository.dart';
import '../domain/repositories/admin_users_repository.dart';
import '../domain/repositories/admin_wallet_deposit_repository.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../services/dashboard_admin_service.dart';

final dashboardSectionProvider = StateProvider<DashboardSection>(
  (ref) => DashboardSection.overview,
);

final dashboardAdminServiceProvider = Provider<DashboardAdminService>((ref) {
  return DashboardAdminService(Supabase.instance.client);
});

final dashboardDatasourceProvider = Provider<DashboardDatasource>((ref) {
  return DashboardSupabaseDatasource(Supabase.instance.client);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardDatasourceProvider));
});

final dashboardOverviewProvider = FutureProvider<DashboardOverview>((ref) {
  return ref.watch(dashboardRepositoryProvider).loadOverview();
});

final dashboardAccessProvider = FutureProvider<bool>((ref) {
  return ref.watch(dashboardAdminServiceProvider).isCurrentUserAdmin();
});

final dashboardSnapshotProvider = FutureProvider<DashboardSnapshot>((
  ref,
) async {
  final results = await Future.wait<Object>([
    ref.watch(dashboardAdminServiceProvider).loadDashboard(),
    ref.watch(dashboardOverviewProvider.future),
  ]);
  return (results[0] as DashboardSnapshot).withOverview(
    results[1] as DashboardOverview,
  );
});

final adminVerificationDatasourceProvider =
    Provider<AdminVerificationDatasource>((ref) {
      return AdminVerificationDatasource(Supabase.instance.client);
    });

final adminVerificationRepositoryProvider =
    Provider<AdminVerificationRepository>((ref) {
      return AdminVerificationRepositoryImpl(
        ref.watch(adminVerificationDatasourceProvider),
      );
    });

final adminPendingVerificationProvider =
    FutureProvider<List<DashboardVerificationRequest>>((ref) {
      return ref
          .watch(adminVerificationRepositoryProvider)
          .loadPendingRequests();
    });

class VerificationActionController extends StateNotifier<Set<String>> {
  VerificationActionController(this._repository) : super(const {});

  final AdminVerificationRepository _repository;

  Future<bool> process({
    required String requestId,
    required bool approve,
    String? rejectionReason,
  }) async {
    if (state.contains(requestId)) return false;
    state = {...state, requestId};
    try {
      await _repository.processRequest(
        requestId: requestId,
        approve: approve,
        rejectionReason: rejectionReason,
      );
      return true;
    } finally {
      state = {...state}..remove(requestId);
    }
  }
}

final verificationActionControllerProvider =
    StateNotifierProvider<VerificationActionController, Set<String>>((ref) {
      return VerificationActionController(
        ref.watch(adminVerificationRepositoryProvider),
      );
    });

final adminUsersDatasourceProvider = Provider<AdminUsersDatasource>((ref) {
  return AdminUsersDatasource(Supabase.instance.client);
});

final adminUsersRepositoryProvider = Provider<AdminUsersRepository>((ref) {
  return AdminUsersRepositoryImpl(ref.watch(adminUsersDatasourceProvider));
});

final adminWalletDepositDatasourceProvider =
    Provider<AdminWalletDepositDatasource>((ref) {
      return AdminWalletDepositDatasource(Supabase.instance.client);
    });

final adminWalletDepositRepositoryProvider =
    Provider<AdminWalletDepositRepository>((ref) {
      return AdminWalletDepositRepositoryImpl(
        ref.watch(adminWalletDepositDatasourceProvider),
      );
    });

class AdminWalletDepositController extends StateNotifier<bool> {
  AdminWalletDepositController(this._repository, this._onSuccess)
    : super(false);

  final AdminWalletDepositRepository _repository;
  final Future<void> Function() _onSuccess;

  Future<double> getBalance(String userId) => _repository.getBalance(userId);

  Future<AdminWalletDepositResult?> deposit(
    AdminWalletDepositRequest request,
  ) async {
    if (state) return null;
    state = true;
    try {
      final result = await _repository.deposit(request);
      await _onSuccess();
      return result;
    } finally {
      state = false;
    }
  }
}

final adminWalletDepositControllerProvider =
    StateNotifierProvider<AdminWalletDepositController, bool>((ref) {
      return AdminWalletDepositController(
        ref.watch(adminWalletDepositRepositoryProvider),
        () async {
          ref.invalidate(adminUsersControllerProvider);
          ref.invalidate(dashboardOverviewProvider);
          ref.invalidate(dashboardSnapshotProvider);
        },
      );
    });

class AdminUsersController extends StateNotifier<AdminUsersState> {
  AdminUsersController(
    this._repository,
    this._currentUserId, {
    AdminUsersState initialState = const AdminUsersState(),
    bool autoLoad = true,
  }) : super(initialState) {
    if (autoLoad) load();
  }

  final AdminUsersRepository _repository;
  final String? _currentUserId;
  int _requestSequence = 0;

  Future<void> load() async {
    final sequence = ++_requestSequence;
    state = state.copyWith(loading: true, clearError: true);
    try {
      var result = await _repository.loadUsers(state.query);
      if (sequence != _requestSequence) return;
      final corrected = UserPagination.correctedPage(
        state.query.currentPage,
        result.totalUsers,
        state.query.pageSize,
      );
      if (corrected != state.query.currentPage) {
        final correctedQuery = state.query.copyWith(currentPage: corrected);
        state = state.copyWith(query: correctedQuery);
        result = await _repository.loadUsers(correctedQuery);
        if (sequence != _requestSequence) return;
      }
      state = state.copyWith(
        users: result.users,
        totalUsers: result.totalUsers,
        loading: false,
        clearError: true,
      );
    } catch (_) {
      if (sequence != _requestSequence) return;
      state = state.copyWith(
        loading: false,
        errorMessage: 'تعذر تحميل المستخدمين. حاول مرة أخرى.',
      );
    }
  }

  Future<void> setSearch(String value) {
    state = state.copyWith(
      query: state.query.copyWith(currentPage: 1, search: value.trim()),
    );
    return load();
  }

  Future<void> setRole(UserDashboardRole? role) {
    state = state.copyWith(
      query: state.query.copyWith(
        currentPage: 1,
        role: role,
        clearRole: role == null,
      ),
    );
    return load();
  }

  Future<void> setStatus(UserDashboardStatus? status) {
    state = state.copyWith(
      query: state.query.copyWith(
        currentPage: 1,
        status: status,
        clearStatus: status == null,
      ),
    );
    return load();
  }

  Future<void> goToPage(int page) {
    final target = page.clamp(1, state.totalPages);
    if (target == state.query.currentPage || state.loading) {
      return Future.value();
    }
    state = state.copyWith(query: state.query.copyWith(currentPage: target));
    return load();
  }

  Future<bool> setActiveStatus(String userId, bool isActive) async {
    if (!isActive && userId == _currentUserId) {
      throw const AdminUsersActionException(
        'لا يمكنك تعطيل حساب المدير الحالي.',
      );
    }
    if (state.processingUserIds.contains(userId)) return false;
    state = state.copyWith(
      processingUserIds: {...state.processingUserIds, userId},
    );
    try {
      await _repository.setActiveStatus(userId: userId, isActive: isActive);
      await load();
      return true;
    } catch (error) {
      if (error is AdminUsersActionException) rethrow;
      throw const AdminUsersActionException(
        'تعذر تحديث حالة المستخدم. حاول مرة أخرى.',
      );
    } finally {
      state = state.copyWith(
        processingUserIds: {...state.processingUserIds}..remove(userId),
      );
    }
  }
}

class AdminUsersActionException implements Exception {
  const AdminUsersActionException(this.message);
  final String message;

  @override
  String toString() => message;
}

final adminUsersControllerProvider =
    StateNotifierProvider<AdminUsersController, AdminUsersState>((ref) {
      return AdminUsersController(
        ref.watch(adminUsersRepositoryProvider),
        Supabase.instance.client.auth.currentUser?.id,
      );
    });

final dashboardNotificationSettingsProvider =
    FutureProvider<DashboardNotificationSettings>((ref) {
      return ref
          .watch(dashboardAdminServiceProvider)
          .loadMyNotificationSettings();
    });
