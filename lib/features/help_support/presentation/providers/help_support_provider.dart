import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/help_support_providers.dart';
import '../../domain/models/faq_model.dart';
import '../../domain/repositories/help_support_repository.dart';


class FaqsNotifier extends StateNotifier<AsyncValue<List<FaqModel>>> {
  final HelpSupportRepository _repository;

  FaqsNotifier(this._repository) : super(const AsyncLoading());

  Future<void> loadFaqs() async {
    state = const AsyncLoading();
    try {
      final faqs = await _repository.getFaqs();
      state = AsyncData(faqs);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final faqsProvider = StateNotifierProvider<FaqsNotifier, AsyncValue<List<FaqModel>>>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  final notifier = FaqsNotifier(repository);
  notifier.loadFaqs();
  return notifier;
});

class SupportMessageNotifier extends StateNotifier<AsyncValue<void>> {
  final HelpSupportRepository _repository;
  final String _userId;

  SupportMessageNotifier(this._repository, this._userId) : super(const AsyncData(null));

  Future<void> sendMessage({
    required String message,
    String? subject,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.sendSupportMessage(
        userId: _userId,
        message: message,
        subject: subject,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final supportMessageProvider = StateNotifierProvider<SupportMessageNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final user = supabaseClient.auth.currentUser;
  
  if (user == null) throw Exception('User not authenticated');
  
  return SupportMessageNotifier(repository, user.id);
});