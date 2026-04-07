import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/account_settings_model.dart';

class AccountSettingsSupabaseDatasource {
  final SupabaseClient _client;

  AccountSettingsSupabaseDatasource(this._client);

  Future<AccountSettingsModel> getSettings(String userId) async {
    // جلب بيانات من profiles
    final profileResponse = await _client
        .from('profiles')
        .select('id, full_name, phone, avatar_url, city')
        .eq('id', userId)
        .single();

    // جلب بيانات من workers
    final workerResponse = await _client
        .from('workers')
        .select('experience_years, bio')
        .eq('user_id', userId)
        .maybeSingle();

    return AccountSettingsModel(
      id: profileResponse['id'],
      userId: userId,
      fullName: profileResponse['full_name'] ?? '',
      phone: profileResponse['phone'] as String?,
      email: null, // البريد الإلكتروني من auth.users
      avatarUrl: profileResponse['avatar_url'] as String?,
      city: profileResponse['city'] as String?,
      experienceYears: workerResponse?['experience_years'] as int?,
      bio: workerResponse?['bio'] as String?,
    );
  }

// في account_settings_supabase_datasource.dart
Future<AccountSettingsModel> updateSettings({
  required String userId,
  String? fullName,
  String? phone,
  String? avatarUrl,
  String? city,
  int? experienceYears,
  String? bio,
}) async {
  print('🔵 [Datasource] Updating settings for user: $userId');
  print('   experienceYears: $experienceYears');
  print('   bio: $bio');
  
  // تحديث profiles
  final profileUpdates = <String, dynamic>{};
  if (fullName != null) profileUpdates['full_name'] = fullName;
  if (phone != null) profileUpdates['phone'] = phone;
  if (avatarUrl != null) profileUpdates['avatar_url'] = avatarUrl;
  if (city != null) profileUpdates['city'] = city;
  profileUpdates['updated_at'] = DateTime.now().toIso8601String();

  if (profileUpdates.isNotEmpty) {
    print('🔵 [Datasource] Updating profiles: $profileUpdates');
    await _client
        .from('profiles')
        .update(profileUpdates)
        .eq('id', userId);
    print('✅ [Datasource] Profiles updated');
  }

  // تحديث workers
  final workerUpdates = <String, dynamic>{};
  if (experienceYears != null) workerUpdates['experience_years'] = experienceYears;
  if (bio != null) workerUpdates['bio'] = bio;

  if (workerUpdates.isNotEmpty) {
    print('🔵 [Datasource] Updating workers: $workerUpdates');
    
    // ✅ تحقق من وجود سجل worker
    final existingWorker = await _client
        .from('workers')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();
    
    print('🔵 [Datasource] Existing worker: $existingWorker');
    
    if (existingWorker != null) {
      final response = await _client
          .from('workers')
          .update(workerUpdates)
          .eq('user_id', userId);
      print('✅ [Datasource] Workers update response: $response');
    } else {
      // إذا لم يكن هناك سجل، أنشئ واحداً
      print('⚠️ [Datasource] No worker record found, creating new...');
      await _client.from('workers').insert({
        'user_id': userId,
        ...workerUpdates,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('✅ [Datasource] Worker record created');
    }
  } else {
    print('⚠️ [Datasource] No worker updates to apply');
  }

  return getSettings(userId);
}

  Future<String?> uploadAvatar(String userId, String imagePath) async {
    final fileName = 'avatars/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (kIsWeb) {
      final response = await http.get(Uri.parse(imagePath));
      final bytes = response.bodyBytes;
      await _client.storage.from('avatars').uploadBinary(fileName, bytes);
    } else {
      final file = File(imagePath);
      await _client.storage.from('avatars').upload(fileName, file);
    }

    return _client.storage.from('avatars').getPublicUrl(fileName);
  }
}