import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/providers/account_settings_providers.dart';
import '../../domain/models/account_settings_model.dart';
import '../../domain/repositories/account_settings_repository.dart';

class AccountSettingsNotifier extends StateNotifier<AsyncValue<AccountSettingsModel>> {
  final AccountSettingsRepository _repository;
  final String _userId;

  AccountSettingsNotifier(this._repository, this._userId)
      : super(const AsyncLoading());

  Future<void> loadSettings() async {
    state = const AsyncLoading();
    try {
      final settings = await _repository.getSettings(_userId);
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

 Future<void> updateSettings({
  String? fullName,
  String? phone,
  String? avatarUrl,
  String? city,
  int? experienceYears,
  String? bio,
}) async {
  state.whenData((current) async {
    try {
      state = const AsyncLoading();
      final updated = await _repository.updateSettings(
        userId: _userId,
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
        city: city,
        experienceYears: experienceYears,
        bio: bio,
      );
      state = AsyncData(updated);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  });
}

  Future<String?> pickAndUploadAvatar() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image == null) return null;

      final avatarUrl = await _repository.uploadAvatar(_userId, image.path);
      await updateSettings(avatarUrl: avatarUrl);
      return avatarUrl;
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }
}

final accountSettingsProvider = StateNotifierProvider<AccountSettingsNotifier, AsyncValue<AccountSettingsModel>>((ref) {
  final repository = ref.watch(accountSettingsRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  final notifier = AccountSettingsNotifier(repository, user.id);
  notifier.loadSettings();
  return notifier;
});

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());