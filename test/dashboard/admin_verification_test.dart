import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/DashBoard/data/datasources/admin_verification_datasource.dart';
import 'package:hirfati/DashBoard/domain/repositories/admin_verification_repository.dart';
import 'package:hirfati/DashBoard/domain/repositories/dashboard_repository.dart';
import 'package:hirfati/DashBoard/models/dashboard_models.dart';
import 'package:hirfati/DashBoard/providers/dashboard_providers.dart';

void main() {
  test('pending query targets all pending requests ordered newest first', () {
    expect(AdminVerificationDatasource.pendingQuery, {
      'table': 'verification_requests',
      'status': 'pending',
      'orderBy': 'created_at',
      'ascending': false,
    });
  });

  test('parses pending request numeric and optional fields safely', () {
    final request = DashboardVerificationRequest.fromJson({
      'id': '766fff8d-ea00-4f40-845f-70fbd97a60e1',
      'user_id': '33379f9d-3734-4a8f-90c4-750598dcad99',
      'full_name': 'Worker',
      'age': 31.0,
      'email': 'worker@example.com',
      'status': 'pending',
      'rejection_reason': null,
      'created_at': '2026-08-06T10:00:00Z',
      'updated_at': null,
    });

    expect(request.id, '766fff8d-ea00-4f40-845f-70fbd97a60e1');
    expect(request.age, 31);
    expect(request.status, VerificationDashboardStatus.pending);
    expect(request.rejectionReason, isNull);
    expect(request.passportUrl, isNull);
    expect(request.selfieUrl, isNull);
  });

  test('splits combined national ID into safe front and back URLs', () {
    final documents = VerificationDocumentUrls.parseNationalId(
      ' front:https://example.com/front.jpg | back:https://example.com/back.jpg ',
    );

    expect(documents.frontUrl, 'https://example.com/front.jpg');
    expect(documents.backUrl, 'https://example.com/back.jpg');
  });

  test('malformed optional documents do not hide the request', () {
    final request = DashboardVerificationRequest.fromJson({
      'id': 'request-2',
      'user_id': 'user-2',
      'age': 'not-a-number',
      'national_id_url': 'front: | unexpected-value | back:',
      'passport_url': '',
      'selfie_url': null,
      'status': 'pending',
      'created_at': 'malformed-date',
    });

    expect(request.id, 'request-2');
    expect(request.age, isNull);
    expect(request.nationalIdFrontUrl, isNull);
    expect(request.nationalIdBackUrl, isNull);
    expect(request.attachments, isEmpty);
    expect(request.requestedAt, isNull);
  });

  test('maps approval and rejection RPC parameters', () {
    expect(
      AdminVerificationDatasource.processParameters(
        requestId: 'request-1',
        approve: true,
      ),
      {
        'p_request_id': 'request-1',
        'p_status': 'approved',
        'p_rejection_reason': null,
      },
    );
    expect(
      AdminVerificationDatasource.processParameters(
        requestId: 'request-1',
        approve: false,
        rejectionReason: ' Invalid document ',
      ),
      {
        'p_request_id': 'request-1',
        'p_status': 'rejected',
        'p_rejection_reason': 'Invalid document',
      },
    );
  });

  test('prevents duplicate processing for the same request', () async {
    final repository = _PendingVerificationRepository();
    final controller = VerificationActionController(repository);
    final first = controller.process(requestId: 'request-1', approve: true);
    final duplicate = await controller.process(
      requestId: 'request-1',
      approve: true,
    );

    expect(duplicate, isFalse);
    expect(repository.calls, 1);
    repository.completer.complete();
    expect(await first, isTrue);
  });

  test(
    'invalidating Dashboard overview reloads pending counter data',
    () async {
      final repository = _CountingDashboardRepository();
      final container = ProviderContainer(
        overrides: [dashboardRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(dashboardOverviewProvider.future);
      container.invalidate(dashboardOverviewProvider);
      await container.read(dashboardOverviewProvider.future);

      expect(repository.calls, 2);
    },
  );
}

class _PendingVerificationRepository implements AdminVerificationRepository {
  final completer = Completer<void>();
  int calls = 0;

  @override
  Future<List<DashboardVerificationRequest>> loadPendingRequests() async => [];

  @override
  Future<void> processRequest({
    required String requestId,
    required bool approve,
    String? rejectionReason,
  }) {
    calls++;
    return completer.future;
  }
}

class _CountingDashboardRepository implements DashboardRepository {
  int calls = 0;

  @override
  Future<DashboardOverview> loadOverview() async {
    calls++;
    return const DashboardOverview(
      metrics: DashboardMetrics.zero,
      latestUsers: [],
      topWorkers: [],
      topCategories: [],
      recentActivity: [],
    );
  }
}
