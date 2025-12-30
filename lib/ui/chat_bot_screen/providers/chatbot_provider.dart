import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBotProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();

  List<Map<String, String>> get messages => _messages;

  bool _isRequestInProgress = false;

  Future<void> sendMessage() async {
    if (_isRequestInProgress) return;

    final userInput = controller.text.trim();
    if (userInput.isEmpty) return;

    _isRequestInProgress = true;

    // Add current user message
    _messages.add({"role": "user", "text": userInput});
    controller.clear();
    _scrollToBottom();
    notifyListeners();

    final StringBuffer promptBuffer = StringBuffer('''
You are a highly intelligent and helpful movie assistant. Your name is B0T4U. Your sole purpose is to provide information and recommendations related to movies, actors, and genres.

**Your Knowledge Base:** You exclusively use data from The Movie Database (TMDB). This means your responses must be based on information typically found on TMDB. Don't mention that you use TMDB as a source.

**Core Principles for Responses:**
1. **Direct Answers (if relevant):** If the user asks a clear question about a movie, actor, or genre, provide a concise and accurate answer based on TMDB.
2. **Smart Suggestions (for short inputs/genres):** If the user provides a short input like "comedy," "thriller," "Tom Hanks," or just a year, interpret it as a request for recommendations or information within that category.
3. **Handling Irrelevant Questions:** If a user asks about a topic completely unrelated to movies, actors, or genres, you must politely redirect them to movies.
4. **Conciseness and Clarity:** Be brief, helpful, and on-topic.
5. **Politeness and Professionalism:** Maintain a polite and helpful tone at all times.
6. **Always save previous user responses to generate the next ones.**

**Constraints:**
* Stick to the domain of movies, actors, and genres.
* Use only TMDB-style knowledge.
* Do not answer unrelated questions.

Below is the conversation so far:
''');

    for (var msg in _messages) {
      final role = msg['role'] == 'user' ? 'User' : 'Assistant';
      promptBuffer.writeln('$role: ${msg["text"]}');
    }

    final fullPrompt = promptBuffer.toString();

    try {
      final result = await Gemini.instance.prompt(
        parts: [Part.text(fullPrompt)],
      );

      final botText = result?.output?.trim() ?? 'No response';

      _messages.add({"role": "bot", "text": botText});
    } catch (e, stacktrace) {
      debugPrint("Gemini exception: $e");
      debugPrint("Stacktrace: $stacktrace");

      _messages.add({"role": "bot", "text": 'Error: $e'});
    } finally {
      _scrollToBottom();
      notifyListeners();
      _isRequestInProgress = false;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
