import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/workersetupstate_model.dart';

final workerSetupProvider =
    NotifierProvider<WorkerSetupNotifier, WorkerSetupState>(
      WorkerSetupNotifier.new,
    );

class WorkerSetupNotifier extends Notifier<WorkerSetupState> {
  @override
  WorkerSetupState build() => const WorkerSetupState();

  void setCategory(String id) {
    state = state.copyWith(categoryId: id);
  }

  void setExperience(int years) {
    state = state.copyWith(experienceYears: years);
  }

  void setBio(String value) {
    state = state.copyWith(bio: value);
  }

  void setPriceMin(double? value) {
    state = state.copyWith(priceMin: value);
  }

  void setPriceMax(double? value) {
    state = state.copyWith(priceMax: value);
  }

  void reset() {
    state = const WorkerSetupState();
  }
}
