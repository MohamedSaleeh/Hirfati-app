import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/models/profile_setup_state.dart';
import '../../data/repositories/profile_repository.dart';

// ------------------------------------------------------------------
// Provider
// ------------------------------------------------------------------

final profileSetupProvider =
    AsyncNotifierProvider<ProfileSetupController, ProfileSetupState>(
      ProfileSetupController.new,
    );

// ------------------------------------------------------------------
// Controller
// ------------------------------------------------------------------

class ProfileSetupController extends AsyncNotifier<ProfileSetupState> {
  late final ProfileRepository _repo;
  final _imagePicker = ImagePicker();

  @override
  Future<ProfileSetupState> build() async {
    _repo = ProfileRepositoryImpl(
      ProfileRemoteDatasource(Supabase.instance.client),
    );
    return const ProfileSetupState();
  }

  // ----------------------------------------------------------------
  // Setters
  // ----------------------------------------------------------------

  void setCity(String city) {
    state = AsyncData(state.requireValue.copyWith(city: city));
  }

  void setLocation(double lat, double lng) {
    state = AsyncData(
      state.requireValue.copyWith(latitude: lat, longitude: lng),
    );
  }

  void sethasCompletedOnboarding(bool value) {
    state = AsyncData(
      state.requireValue.copyWith(hasCompletedOnboarding: value),
    );
  }

  // ----------------------------------------------------------------
  // Image picker
  // ----------------------------------------------------------------

  Future<void> pickImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      state = AsyncData(
        state.requireValue.copyWith(avatarLocalPath: picked.path),
      );
    } catch (e) {
      state = AsyncData(
        state.requireValue.copyWith(errorMessage: 'Failed to pick image: $e'),
      );
    }
  }

  // ----------------------------------------------------------------
  // Submit
  // ----------------------------------------------------------------

  Future<bool> submit() async {
    final current = state.requireValue;

    // Basic validation
    if (current.city.isEmpty) {
      state = AsyncData(current.copyWith(errorMessage: 'Please select a city'));
      return false;
    }
    if (current.latitude == null || current.longitude == null) {
      state = AsyncData(
        current.copyWith(
          errorMessage: 'Please select your location on the map',
        ),
      );
      return false;
    }

    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    try {
      await _repo.completeProfile(
        avatarLocalPath: current.avatarLocalPath,
        city: current.city,
        latitude: current.latitude,
        longitude: current.longitude,
      );
      state = AsyncData(
        current.copyWith(
          isProfileCompleted: true,
          hasCompletedOnboarding: true,
          isLoading: false,
        ),
      );
      return true;
    } catch (e) {
      state = AsyncData(
        current.copyWith(isLoading: false, errorMessage: e.toString()),
      );
      return false;
    }
  }

  // ----------------------------------------------------------------
  // skip screen profile setup
  // ----------------------------------------------------------------

  Future<void> skipOnboarding() async {
    final current = state.requireValue;

    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    try {
      await _repo.setOnboardingCompleted(true);

      state = AsyncData(
        current.copyWith(hasCompletedOnboarding: true, isLoading: false),
      );
    } catch (e) {
      state = AsyncData(
        current.copyWith(isLoading: false, errorMessage: 'Failed to skip: $e'),
      );
    }
  }

  Future<bool> checkProfileCompletedForUser() async {
    try {
      final completed = await _repo.isProfileCompletedForUser();
      state = AsyncData(
        state.requireValue.copyWith(hasCompletedOnboarding: completed),
      );
      return completed;
    } catch (e) {
      return state.requireValue.hasCompletedOnboarding;
    }
  }

  Future<bool> checkProfileCompleted() async {
    try {
      final completed = await _repo.isProfileCompleted();
      state = AsyncData(
        state.requireValue.copyWith(isProfileCompleted: completed),
      );
      return completed;
    } catch (e) {
      return state.requireValue.isProfileCompleted;
    }
  }
}
