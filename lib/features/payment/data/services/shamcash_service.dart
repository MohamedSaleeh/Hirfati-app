import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShamCashService {
  final SupabaseClient _supabase;

  ShamCashService(this._supabase);

  Future<double> getShamCashBalance() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 0;

    final response = await _supabase
        .from('sham_cash_accounts')
        .select('balance')
        .eq('user_id', user.id)
        .maybeSingle();

    return (response?['balance'] as num?)?.toDouble() ?? 0;
  }

  Future<ShamCashSession> createSession({
    required String orderId,
    required double amount,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final serviceRoleKey = dotenv.env['SUPABASE_SERVICE_ROLE_KEY']!;

    print('📡 Creating ShamCash session');
    print('   - URL: $supabaseUrl/functions/v1/shamcash-payment');
    print('   - Order ID: $orderId');
    print('   - Amount: $amount');
    print('   - User ID: ${user.id}');

    final response = await http.post(
      Uri.parse('$supabaseUrl/functions/v1/shamcash-payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serviceRoleKey',
        'apikey': serviceRoleKey,
      },
      body: jsonEncode({
        'action': 'create-session',
        'orderId': orderId,
        'amount': amount,
        'userId': user.id,
      }),
    );

    print('📡 Response status: ${response.statusCode}');
    print('📡 Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to create session: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ShamCashSession.fromJson(data);
  }

  Future<ShamCashResult> confirmPayment({
    required String orderId,
    required String pin,
    required String idempotencyKey,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final serviceRoleKey = dotenv.env['SUPABASE_SERVICE_ROLE_KEY']!;

    print('🔐 Confirming payment');
    print('   - Order ID: $orderId');
    print('   - User ID: ${user.id}');
    print('   - PIN: $pin');
    print('   - Idempotency Key: $idempotencyKey');

    final response = await http.post(
      Uri.parse('$supabaseUrl/functions/v1/shamcash-payment'),
      headers: {
        'Content-Type': 'application/json', // ✅ تم إصلاح الخطأ هنا
        'Authorization': 'Bearer $serviceRoleKey',
        'apikey': serviceRoleKey,
      },
      body: jsonEncode({
        'action': 'confirm-payment', // ✅ تم إصلاح: confirm-payment (بدون مسافة)
        'orderId': orderId,
        'pin': pin,
        'userId': user.id, // ✅ تم إصلاح: userId (كانت userid)
        'idempotencyKey': idempotencyKey,
      }),
    );

    print('📡 Response status: ${response.statusCode}');
    print('📡 Response body: ${response.body}');

    if (response.statusCode != 200) {
      return ShamCashResult.failure('Payment failed: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ShamCashResult.success(data);
  }
}

class ShamCashSession {
  final bool success;
  final String referenceNumber;
  final String paymentUrl;
  final DateTime expiresAt;
  final double amount;
  final String merchant;
  final String? paymentId;

  ShamCashSession({
    required this.success,
    required this.referenceNumber,
    required this.paymentUrl,
    required this.expiresAt,
    required this.amount,
    required this.merchant,
    this.paymentId,
  });

  factory ShamCashSession.fromJson(Map<String, dynamic> json) {
    return ShamCashSession(
      success: json['success'] ?? true,
      referenceNumber: json['reference_number'],
      paymentUrl: json['payment_url'],
      expiresAt: DateTime.parse(json['expires_at']),
      amount: (json['amount'] as num).toDouble(),
      merchant: json['merchant'],
      paymentId: json['payment_id'],
    );
  }
}

class ShamCashResult {
  final bool success;
  final Map<String, dynamic>? data;
  final String? error;

  ShamCashResult._({required this.success, this.data, this.error});

  factory ShamCashResult.success(Map<String, dynamic> data) {
    return ShamCashResult._(success: true, data: data);
  }

  factory ShamCashResult.failure(String error) {
    return ShamCashResult._(success: false, error: error);
  }
}
