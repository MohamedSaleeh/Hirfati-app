import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_client_repo_provider.dart';
import '../../domain_models/craftsman_model.dart';

/// Searches craftsmen by query. Pass empty string to get all recommended.
final searchCraftsmenProvider =
    FutureProvider.family<List<CraftsmanModel>, String>((ref, query) async {
  final repo = ref.read(homeClientRepositoryProvider);
  return repo.searchCraftsmen(query);
});
