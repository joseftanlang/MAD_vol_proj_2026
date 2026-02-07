import 'package:final_project_flutter/components/appBar.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  static final GenerativeModel _model =
      FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
      );

  static final ChatSession _chat = _model.startChat();

  static Future<String> reply(String userText) async {
    final response = await _chat.sendMessage(
      Content.text(userText),
    );

    return response.text ?? '(No reply)';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  bool _sending = false;

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _controller.clear();
      _sending = true;
    });

    try {
      final botReply = await GeminiService.reply(text);

      setState(() {
        _messages.add(ChatMessage(text: botReply, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(text: 'Error: $e', isUser: false),
        );
      });
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(),
      drawer: const DrawerNav(),
      body: Column(
        children: [
          /// Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Colors.teal.shade200
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),

          if (_sending)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text('Gemini is typing...'),
            ),

          /// Input
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sending ? null : _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}