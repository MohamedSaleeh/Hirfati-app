import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../translations.dart';
import '../../data/providers/chat_providers.dart';
import '../providers/chat_form_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/scroll_provider.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollToBottom();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow =
        _scrollController.hasClients &&
        _scrollController.position.maxScrollExtent >
            _scrollController.position.pixels + 100;

    ref.read(scrollVisibilityProvider.notifier).state = shouldShow;
  }

  void _initializeProviders() {
    if (_isInitialized) return;

    ref.read(conversationIdProvider.notifier).state = widget.conversationId;
    ref.read(receiverIdProvider.notifier).state = widget.otherUserId;

    _isInitialized = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      ref.read(refreshMessagesProvider)();
      _markAllAsRead();
      _scrollToBottom();
    });
  }

  Future<void> _markAllAsRead() async {
    if (!_isInitialized) return;
    try {
      await ref.read(markAllMessagesAsReadProvider)();
    } catch (e) {}
  }

  Future<void> _sendMessage() async {
    final messageValue = ref.read(chatFormProvider).control('message').value;
    if (messageValue == null || messageValue.isEmpty) return;

    final sendMessage = ref.read(sendMessageProvider);

    try {
      await sendMessage(messageValue);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sending message'.i18n)));
      }
    }
  }

  Future<void> _deleteMessage(String messageId) async {
    try {
      final deleteMessage = ref.read(deleteMessageProvider);
      await deleteMessage(messageId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message deleted'.i18n),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting message'.i18n),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _refreshMessages() async {
    ref.read(refreshMessagesProvider)();
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollToBottom();
  }

  Future<void> _pickAndSendImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();
        final repository = ref.read(chatRepositoryProvider);
        final currentUser = Supabase.instance.client.auth.currentUser;

        if (currentUser != null) {
          final imageUrl = await repository.uploadAttachment(
            currentUser.id,
            pickedFile.name,
            bytes,
          );

          if (imageUrl != null) {
            final sendImage = ref.read(sendImageProvider);
            await sendImage(imageUrl);
            _scrollToBottom();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error sending image'.i18n)));
        }
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final messagesAsync = ref.watch(chatMessagesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.otherUserAvatar != null
                  ? NetworkImage(widget.otherUserAvatar!)
                  : null,
              child: widget.otherUserAvatar == null
                  ? Text(widget.otherUserName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Text(widget.otherUserName),
          ],
        ),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMessages,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.block),
                        title: Text('Block user'.i18n),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.report),
                        title: Text('Report user'.i18n),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMessages,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: messagesAsync.when(
                    data: (messages) {
                      if (messages.isEmpty) {
                        return _buildEmptyChat();
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final currentUser =
                              Supabase.instance.client.auth.currentUser;
                          final isMe = message.senderId == currentUser?.id;
                          return MessageBubble(
                            message: message,
                            isMe: isMe,
                            onDelete: isMe
                                ? () => _deleteMessage(message.id)
                                : null,
                          );
                        },
                      );
                    },
                    loading: () => Center(
                      child: Lottie.asset(
                        'assets/animations/loading_animation.json',
                        width: 150,
                        height: 150,
                        repeat: true,
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error loading messages'.i18n),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshMessages,
                            child: Text('Retry'.i18n),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ChatInputField(
                  onSendMessage: _sendMessage,
                  onPickImage: _pickAndSendImage,
                ),
              ],
            ),
            Consumer(
              builder: (context, showScrollButton, child) {
                final isVisible = ref.watch(scrollVisibilityProvider);
                return Positioned(
                  bottom: 80,
                  left: 24,
                  child: AnimatedOpacity(
                    opacity: isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _scrollToBottom,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.6,
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChat() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text('Start a conversation'.i18n, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Say hello to ${widget.otherUserName}'.i18n,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
