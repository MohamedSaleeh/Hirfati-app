import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_client_repo_provider.dart';
import '../../domain_models/craftsman_model.dart';

/// Provides a live-refreshing list of nearby craftsmen.
///
/// This replaces [craftsmenStreamProvider] as the canonical provider for the
/// Live Map card and is also safe to use from the home screen widget tree.
///
/// Usage:
/// ```dart
/// final nearbyAsync = ref.watch(getNearbyWorkersProvider);
/// ```
final getNearbyWorkersProvider = FutureProvider<List<CraftsmanModel>>((ref) {
  return ref.read(homeClientRepositoryProvider).getNearbyCraftsmen();
});
