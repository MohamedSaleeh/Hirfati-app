import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/category_model.dart';
import '../../domain/models/worker_profile_model.dart';
import '../datasources/worker_profile_supabase_datasource.dart';
import 'worker_profile_repository.dart';

// Provider for the repository
final workerProfileRepositoryProvider = Provider<WorkerProfileRepository>((ref) {
  return WorkerProfileRepositoryImpl(
    WorkerProfileSupabaseDatasource(Supabase.instance.client),
  );
});

class WorkerProfileRepositoryImpl implements WorkerProfileRepository {
  final WorkerProfileSupabaseDatasource _datasource;

  WorkerProfileRepositoryImpl(this._datasource);

  @override
  Future<List<CategoryModel>> getCategories() =>
      _datasource.fetchCategories();

  @override
  Future<void> submitProfile(WorkerProfileModel profile) =>
      _datasource.submitProfile(profile);
}
