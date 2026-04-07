import '../../domain/models/faq_model.dart';
import '../../domain/models/support_message_model.dart';
import '../../domain/repositories/help_support_repository.dart';
import '../datasources/help_support_supabase_datasource.dart';

class HelpSupportRepositoryImpl implements HelpSupportRepository {
  final HelpSupportSupabaseDatasource _datasource;

  HelpSupportRepositoryImpl(this._datasource);

  @override
  Future<List<FaqModel>> getFaqs() async {
    return await _datasource.getFaqs();
  }

  @override
  Future<void> sendSupportMessage({
    required String userId,
    required String message,
    String? subject,
  }) async {
    await _datasource.sendSupportMessage(
      userId: userId,
      message: message,
      subject: subject,
    );
  }

  @override
  Future<List<SupportMessageModel>> getUserMessages(String userId) async {
    return await _datasource.getUserMessages(userId);
  }
}