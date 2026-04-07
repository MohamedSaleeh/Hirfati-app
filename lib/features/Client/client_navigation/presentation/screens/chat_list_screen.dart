import 'package:flutter/material.dart';

import '../../../../chat/presentation/screens/conversations_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: ConversationsScreen()));
  }
}
