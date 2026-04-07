import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/category_model.dart';
import '../../domain/models/worker_profile_model.dart';

class WorkerProfileSupabaseDatasource {
  final SupabaseClient _client;

  WorkerProfileSupabaseDatasource(this._client);

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _client
        .from('categories')
        .select('id, name, icon')
        .order('name');

    return (response as List<dynamic>)
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> submitProfile(WorkerProfileModel profile) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User is not logged in.');
    }

    try {
      await _createShamCashAccount(userId, profile.shamCashCode);

      await _client.from('workers').insert({
        'user_id': userId,
        'category_id': profile.categoryId,
        'experience_years': profile.experienceYears,
        'bio': profile.bio,
        'price_min': profile.priceMin,
        'price_max': profile.priceMax,
        'is_available': profile.isAvailable,
        'approved': false,
        'profile_completed': true,
      });

      await _client
          .from('profiles')
          .update({
            'latitude': profile.latitude,
            'longitude': profile.longitude,
          })
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _createShamCashAccount(String userId, String accountCode) async {
    final userAccount = await _client
        .from('sham_cash_accounts')
        .select('user_id, account_code')
        .eq('user_id', userId)
        .maybeSingle();

    if (userAccount != null) {
      final existingWithCode = await _client
          .from('sham_cash_accounts')
          .select('user_id')
          .eq('account_code', accountCode)
          .neq('user_id', userId)
          .maybeSingle();

      if (existingWithCode != null) {
        throw Exception(
          'Sham Cash code already exists. Please use another code.',
        );
      }

      await _client
          .from('sham_cash_accounts')
          .update({
            'account_code': accountCode,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);
      return;
    }

    final existingAccount = await _client
        .from('sham_cash_accounts')
        .select('user_id')
        .eq('account_code', accountCode)
        .maybeSingle();

    if (existingAccount != null) {
      throw Exception(
        'Sham Cash code already exists. Please use another code.',
      );
    }

    await _client.rpc(
      'create_sham_cash_account',
      params: {'p_account_code': accountCode, 'p_pin': '1234'},
    );
  }
}
