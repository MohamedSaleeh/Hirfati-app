import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/work_gallery_supabase_datasource.dart';
import '../repositories/work_gallery_repository_impl.dart';
import '../../domain/repositories/work_gallery_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final workGalleryDatasourceProvider = Provider<WorkGallerySupabaseDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WorkGallerySupabaseDatasource(client);
});

final workGalleryRepositoryProvider = Provider<WorkGalleryRepository>((ref) {
  final datasource = ref.watch(workGalleryDatasourceProvider);
  return WorkGalleryRepositoryImpl(datasource);
});