import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/admin_wallet_deposit_repository.dart';
import '../../models/admin_wallet_deposit_models.dart';
import '../datasources/admin_wallet_deposit_datasource.dart';

class AdminWalletDepositRepositoryImpl implements AdminWalletDepositRepository {
  AdminWalletDepositRepositoryImpl(this._datasource);
  final AdminWalletDepositDatasource _datasource;

  static const knownErrors = {
    'unauthenticated',
    'forbidden',
    'target_user_not_found',
    'target_must_be_client',
    'inactive_target_account',
    'invalid_deposit_amount',
    'missing_external_reference',
    'missing_idempotency_key',
    'wallet_locked',
    'idempotency_conflict',
  };

  @override
  Future<double> getBalance(String userId) => _datasource.getBalance(userId);

  @override
  Future<AdminWalletDepositResult> deposit(
    AdminWalletDepositRequest request,
  ) async {
    final validation = request.validate();
    if (validation != null) throw AdminWalletDepositException(validation);
    try {
      return await _datasource.deposit(request);
    } on PostgrestException catch (error) {
      final code = knownErrors.firstWhere(
        error.message.contains,
        orElse: () => 'unexpected',
      );
      throw AdminWalletDepositException(code);
    }
  }
}
