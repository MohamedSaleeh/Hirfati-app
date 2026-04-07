// lib/features/client_profile/data/datasources/client_profile_supabase_datasource.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/client_profile.dart';

class ClientProfileSupabaseDatasource {
  final SupabaseClient _client;

  ClientProfileSupabaseDatasource(this._client);

  Future<ClientProfile> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ClientProfile.fromJson(response);
  }

  Future<ClientProfile> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
  }) async {
    final updates = <String, dynamic>{};

    if (fullName != null) updates['full_name'] = fullName;
    if (phoneNumber != null) updates['phone'] = phoneNumber;
    updates['updated_at'] = DateTime.now().toIso8601String();
    if (updates.isNotEmpty) {
      await _client
          .from('profiles')
          .update(updates)
          .eq('id', userId);
    }

    return getProfile(userId);
  }

  Future<String> uploadAvatar({
    required String userId,
    required String imagePath,
  }) async {
    final fileName = 'avatars/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (kIsWeb) {
      return await _uploadAvatarWeb(imagePath, fileName);
    } else {
      return await _uploadAvatarMobile(imagePath, fileName);
    }
  }

  Future<String> _uploadAvatarMobile(String imagePath, String fileName) async {
    final file = File(imagePath);
    await _client.storage.from('avatars').upload(
      fileName,
      file,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: true,
      ),
    );
    return _client.storage.from('avatars').getPublicUrl(fileName);
  }

  Future<String> _uploadAvatarWeb(String imageUrl, String fileName) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch image from URL');
    }

    final bytes = response.bodyBytes;
    await _client.storage.from('avatars').uploadBinary(
      fileName,
      bytes,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: true,
      ),
    );
    return _client.storage.from('avatars').getPublicUrl(fileName);
  }

  Future<void> updateAvatarUrl({
    required String userId,
    required String avatarUrl,
  }) async {
    await _client
        .from('profiles')
        .update({'avatar_url': avatarUrl})
        .eq('id', userId);
  }
}