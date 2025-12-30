import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/ui/chat_bot_screen/providers/chatbot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBotContentWidget extends StatefulWidget {
  const ChatBotContentWidget({super.key});

  @override
  State<ChatBotContentWidget> createState() => _ChatBotContentWidgetState();
}

class _ChatBotContentWidgetState extends State<ChatBotContentWidget> {
  late ChatBotProvider chatProvider;
  @override
  void initState() {
    chatProvider = context.read<ChatBotProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBotProvider>(builder: (context, chatProvider, _) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: chatProvider.scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                itemCount: chatProvider.messages.length,
                itemBuilder: (_, index) {
                  final msg = chatProvider.messages[index];
                  final isUser = msg["role"] == "user";
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppStyles.userBubbleColor
                            : AppStyles.botBubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(17),
                          topRight: const Radius.circular(17),
                          bottomLeft:
                              isUser ? const Radius.circular(17) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : const Radius.circular(17),
                        ),
                      ),
                      child: Text(
                        msg["text"] ?? '',
                        style: TextStyle(
                          color: isUser
                              ? AppStyles.userTextColor
                              : AppStyles.botTextColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatProvider.controller,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Ask for movie recommendations...",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppStyles.sendButtonColor,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: chatProvider.sendMessage,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
