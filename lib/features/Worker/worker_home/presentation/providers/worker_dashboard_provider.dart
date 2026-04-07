import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/worker_home_providers.dart';
import '../../domain/models/worker_dashboard_data.dart';

final workerDashboardProvider =
    FutureProvider<WorkerDashboardData>((ref) async {
  final repo = ref.read(workerHomeRepositoryProvider);
  return repo.getDashboard();
});
