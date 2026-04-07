import 'package:supabase_flutter/supabase_flutter.dart';

class AuthSupabaseDatasource {
  final SupabaseClient _client;
  
  AuthSupabaseDatasource(this._client);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Future<void> resetPasswordForEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> updateUserPassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // Profiles
  Future<void> insertProfile({
    required String id,
    required String fullName,
    required String role,
    required String phone,
  }) async {
    await _client.from('profiles').insert({
      'id': id,
      'full_name': fullName,
      'role': role,
      'phone': phone,
    });
  }

  Future<Map<String, dynamic>?> getUserRole(String userId) async {
    return await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
  }

  Future<bool> isWorkerProfileCompleted(String userId) async {
  final response = await _client
      .from('workers')
      .select('profile_completed')
      .eq('user_id', userId)
      .maybeSingle();

  if (response == null) return false;
  return response['profile_completed'] as bool? ?? false;
}

}