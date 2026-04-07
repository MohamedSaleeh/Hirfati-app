import 'package:supabase_flutter/supabase_flutter.dart';

class PinSupabaseDatasource {
  final SupabaseClient _client;

  PinSupabaseDatasource(this._client);

  Future<bool> hasPin(String userId) async {
    final response = await _client
        .from('sham_cash_accounts')
        .select('pin_hash')
        .eq('user_id', userId)
        .maybeSingle();

    final pinHash = response?['pin_hash'] as String?;
    return pinHash != null && pinHash.isNotEmpty;
  }

  Future<void> setPin(String userId, String pin) async {
    // ✅ استخدام دالة SQL لتحديث PIN
    await _client.rpc(
      'update_sham_cash_pin',
      params: {'p_user_id': userId, 'p_pin': pin},
    );
  }

  Future<bool> verifyPin(String userId, String pin) async {
    // ✅ استخدام دالة SQL للتحقق من PIN
    final response = await _client.rpc(
      'verify_sham_cash_pin',
      params: {'p_user_id': userId, 'p_pin': pin},
    );

    return response as bool? ?? false;
  }

  Future<void> changePin(String userId, String newPin) async {
    await _client.rpc(
      'update_sham_cash_pin',
      params: {'p_user_id': userId, 'p_pin': newPin},
    );
  }

  Future<void> resetPin(String userId) async {
    await _client
        .from('sham_cash_accounts')
        .update({'pin_hash': null})
        .eq('user_id', userId);
  }

  Future<int> getRemainingAttempts(String userId) async {
    final response = await _client
        .from('sham_cash_accounts')
        .select('pin_attempts')
        .eq('user_id', userId)
        .maybeSingle();

    final attempts = response?['pin_attempts'] as int? ?? 0;
    return 5 - attempts;
  }

  Future<void> incrementAttempts(String userId) async {
    await _client.rpc('increment_pin_attempts', params: {'p_user_id': userId});
  }

  Future<void> resetAttempts(String userId) async {
    await _client
        .from('sham_cash_accounts')
        .update({'pin_attempts': 0, 'last_pin_attempt': null})
        .eq('user_id', userId);
  }
}
