import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/ui/chat_bot_screen/providers/chatbot_provider.dart';
import 'package:app_m0v4u/ui/chat_bot_screen/views/widgets/chat_bot_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../constants/constants.dart';
import '../../../constants/styles.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatBotProvider>(context);
    final messages = chatProvider.messages;

    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: CustomNavBar(),
      body: ChatBotContentWidget(),
    );
  }
}
