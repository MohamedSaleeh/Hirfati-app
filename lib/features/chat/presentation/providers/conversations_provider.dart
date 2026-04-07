import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers/chat_providers.dart';
import '../../domain/models/conversation_model.dart';
import '../../domain/repositories/chat_repository.dart';

class ConversationsNotifier
    extends StateNotifier<AsyncValue<List<ConversationModel>>> {
  final ChatRepository _repository;
  final String _userId;

  ConversationsNotifier(this._repository, this._userId)
    : super(const AsyncLoading()) {
    print('🏗️ ConversationsNotifier created for user: $_userId');
    loadConversations();
  }

  Future<void> loadConversations() async {
    print('🔄 Loading conversations for user: $_userId');
    state = const AsyncLoading();
    try {
      final conversations = await _repository.getConversations(_userId);
      print('✅ Loaded ${conversations.length} conversations');
      state = AsyncData(conversations);
    } catch (e, st) {
      print('❌ Error loading conversations: $e');
      print('Stack trace: $st');
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    await loadConversations();
  }

  Future<int> getTotalUnreadCount() async {
    final conversations = await _repository.getConversations(_userId);
    int total = 0;
    for (final conv in conversations) {
      total += conv.unreadCount;
    }
    return total;
  }
}

final conversationsProvider =
    StateNotifierProvider<
      ConversationsNotifier,
      AsyncValue<List<ConversationModel>>
    >((ref) {
      final repository = ref.watch(chatRepositoryProvider);
      final supabaseClient = ref.watch(supabaseClientProvider);
      final user = supabaseClient.auth.currentUser;

      if (user == null) throw Exception('User not authenticated');

      final notifier = ConversationsNotifier(repository, user.id);
      notifier.loadConversations();
      return notifier;
    });

final unreadMessagesCountProvider = FutureProvider<int>((ref) async {
  final conversationsAsync = ref.watch(conversationsProvider);
  return conversationsAsync.when(
    data: (conversations) {
      int total = 0;
      for (final conv in conversations) {
        total += conv.unreadCount;
      }
      return total;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});
