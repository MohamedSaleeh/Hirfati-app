import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_data_model.dart';

class ProfileRemoteDatasource {
  final SupabaseClient _client;

  ProfileRemoteDatasource(this._client);

  // ----------------------------------------------------------------
  // Upload avatar to Supabase Storage and return public URL
  // ----------------------------------------------------------------
  Future<String?> uploadAvatar(String localPath) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final file = File(localPath);
    final bytes = await file.readAsBytes();
    final storagePath = 'avatars/$userId.jpg';

    await _client.storage
        .from('avatars')
        .uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    return _client.storage.from('avatars').getPublicUrl(storagePath);
  }

  // ----------------------------------------------------------------
  // Update profiles table
  // ----------------------------------------------------------------
  Future<void> updateProfile({
    required String? avatarUrl,
    required String city,
    required double? latitude,
    required double? longitude,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      ProfileDataModel newData = ProfileDataModel(
        id: userId,
        avatarUrl: avatarUrl,
        city: city,
        latitude: latitude,
        longitude: longitude,
        isProfileCompleted: true,
        hasCompletedOnboarding: true,
      );

      await _client.from('profiles').update(newData.toJson()).eq('id', userId);

      print('✅ Profile updated successfully');
      final result = await _client
          .from('profiles')
          .select('city, latitude, longitude, is_profile_completed')
          .eq('id', userId)
          .single();
      print('📊 Updated data: $result');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  Future<bool> isProfileCompletedForUser() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final result = await _client
        .from('profiles')
        .select('has_completed_onboarding')
        .eq('id', userId)
        .single();
    print('📊 Profile completion status: $result[has_completed_onboarding]');
    return result['has_completed_onboarding'] as bool;
  }
  // ---------------------------------
  // Is Profile Completed
  // ---------------------------------

  Future<bool> isProfileCompleted() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception("No user");

    final response = await _client
        .from('profiles')
        .select('is_profile_completed')
        .eq('id', userId)
        .single();

    return response['is_profile_completed'] ?? false;
  }

  // ---------------------------------
  // Set Onboarding Completed
  // ---------------------------------

  Future<void> setOnboardingCompleted(bool completed) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('profiles')
        .update({'has_completed_onboarding': completed})
        .eq('id', userId);
  }
}
