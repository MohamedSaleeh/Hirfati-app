import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import '../../../orders/data/providers/orders_repository_provider.dart';
import '../../data/providers/client_profile_providers.dart' hide supabaseClientProvider;
import '../../domain/models/client_profile.dart';
import '../../domain/repositories/client_profile_repository.dart';


class ClientProfileNotifier extends StateNotifier<AsyncValue<ClientProfile>> {
  final Ref _ref;
  final ClientProfileRepository _repository;

  ClientProfileNotifier(this._ref, this._repository) : super(const AsyncLoading());

  Future<void> loadProfile() async {
    state = const AsyncLoading();
    try {
      final user = _ref.read(supabaseClientProvider).auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final profile = await _repository.getProfile(user.id);
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
  }) async {
    state.whenData((currentProfile) async {
      try {
        final user = _ref.read(supabaseClientProvider).auth.currentUser;
        if (user == null) throw Exception('User not authenticated');

        state = const AsyncLoading();
        
        final updatedProfile = await _repository.updateProfile(
          userId: user.id,
          fullName: fullName,
          phoneNumber: phoneNumber,
        );
        
        state = AsyncData(updatedProfile);
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });
  }

  Future<String?> pickAndUploadAvatar() async {
    try {
      final user = _ref.read(supabaseClientProvider).auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // فتح معرض الصور
      final imagePicker = _ref.read(imagePickerProvider);
      final image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image == null) return null;

      // تحديث الـ state لإظهار الصورة المحلية مؤقتاً
      state.whenData((profile) {
        state = AsyncData(profile.copyWith(
          avatarUrl: image.path, // مؤقتاً
        ));
      });

      // رفع الصورة
      final avatarUrl = await _repository.uploadAvatar(
        userId: user.id,
        imagePath: image.path,
      );

      // تحديث الـ state بالرابط النهائي
      state.whenData((profile) {
        state = AsyncData(profile.copyWith(avatarUrl: avatarUrl));
      });

      return avatarUrl;
    } catch (e) {
      // إعادة التحميل في حالة الخطأ
      await loadProfile();
      rethrow;
    }
  }
}

final clientProfileProvider = StateNotifierProvider<ClientProfileNotifier, AsyncValue<ClientProfile>>((ref) {
  final repository = ref.watch(clientProfileRepositoryProvider);
  
  final notifier = ClientProfileNotifier(ref, repository);
  
  notifier.loadProfile();
  return notifier;
});

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());