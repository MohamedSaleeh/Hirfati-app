import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_client_repo_provider.dart';
import '../../domain_models/craftsman_model.dart';

/// Periodically refreshes nearby craftsmen every 30 seconds.
final craftsmenStreamProvider = StreamProvider<List<CraftsmanModel>>((ref) {
  final repo = ref.read(homeClientRepositoryProvider);

  final controller = StreamController<List<CraftsmanModel>>();

  Future<void> fetch() async {
    try {
      final craftsmen = await repo.getNearbyCraftsmen();
      if (!controller.isClosed) {
        controller.add(craftsmen);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  // Initial fetch
  fetch();

  // Poll every 30 seconds
  final timer = Timer.periodic(const Duration(seconds: 30), (_) => fetch());

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
