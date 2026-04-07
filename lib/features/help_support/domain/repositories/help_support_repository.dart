import '../models/faq_model.dart';
import '../models/support_message_model.dart';

abstract class HelpSupportRepository {
  Future<List<FaqModel>> getFaqs();
  Future<void> sendSupportMessage({
    required String userId,
    required String message,
    String? subject,
  });
  Future<List<SupportMessageModel>> getUserMessages(String userId);
}