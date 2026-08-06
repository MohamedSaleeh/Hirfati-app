import 'package:supabase_flutter/supabase_flutter.dart';

class AdminVerificationDatasource {
  AdminVerificationDatasource(this._client);

  final SupabaseClient _client;

  static const table = 'verification_requests';
  static const pendingStatus = 'pending';
  static const pendingQuery = {
    'table': table,
    'status': pendingStatus,
    'orderBy': 'created_at',
    'ascending': false,
  };

  Future<List<Map<String, dynamic>>> loadPendingRequests() async {
    final response =
        await _client
                .from(table)
                .select(
                  'id, user_id, full_name, age, email, national_id_url, passport_url, '
                  'drivers_license_url, selfie_url, status, rejection_reason, '
                  'created_at, updated_at',
                )
                .eq('status', pendingStatus)
                .order('created_at', ascending: false)
            as List<dynamic>;
    return response
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  Future<List<Map<String, dynamic>>> loadProfiles(List<String> userIds) async {
    if (userIds.isEmpty) return const [];
    final response =
        await _client
                .from('profiles')
                .select('id, full_name, avatar_url, phone, role, is_active')
                .inFilter('id', userIds)
            as List<dynamic>;
    return response
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  static Map<String, dynamic> processParameters({
    required String requestId,
    required bool approve,
    String? rejectionReason,
  }) {
    return {
      'p_request_id': requestId,
      'p_status': approve ? 'approved' : 'rejected',
      'p_rejection_reason': approve ? null : rejectionReason?.trim(),
    };
  }

  Future<void> processRequest({
    required String requestId,
    required bool approve,
    String? rejectionReason,
  }) async {
    await _client.rpc(
      'process_verification_request',
      params: processParameters(
        requestId: requestId,
        approve: approve,
        rejectionReason: rejectionReason,
      ),
    );
  }
}
