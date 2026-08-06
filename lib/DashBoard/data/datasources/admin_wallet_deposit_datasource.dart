import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/admin_wallet_deposit_models.dart';

class AdminWalletDepositDatasource {
  AdminWalletDepositDatasource(this._client);
  final SupabaseClient _client;

  Future<double> getBalance(String userId) async {
    final row = await _client
        .from('wallets')
        .select('balance')
        .eq('user_id', userId)
        .maybeSingle();
    return double.tryParse(row?['balance']?.toString() ?? '') ?? 0;
  }

  Future<AdminWalletDepositResult> deposit(
    AdminWalletDepositRequest request,
  ) async {
    final response = await _client.rpc(
      'admin_credit_wallet',
      params: request.toRpcParameters(),
    );
    return AdminWalletDepositResult.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }
}
