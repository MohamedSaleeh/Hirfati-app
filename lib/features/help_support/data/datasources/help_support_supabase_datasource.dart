import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/faq_model.dart';
import '../../domain/models/support_message_model.dart';

class HelpSupportSupabaseDatasource {
  final SupabaseClient _client;

  HelpSupportSupabaseDatasource(this._client);

  Future<List<FaqModel>> getFaqs() async {
    final response = await _client
        .from('faqs')
        .select()
        .order('order', ascending: true);

    return (response as List)
        .map((json) => FaqModel.fromJson(json))
        .toList();
  }

  Future<void> sendSupportMessage({
    required String userId,
    required String message,
    String? subject,
  }) async {
    await _client.from('support_messages').insert({
      'user_id': userId,
      'message': message,
      'subject': subject,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<SupportMessageModel>> getUserMessages(String userId) async {
    final response = await _client
        .from('support_messages')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => SupportMessageModel.fromJson(json))
        .toList();
  }
}