import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class LegalChatPage extends StatefulWidget {
  const LegalChatPage({super.key});

  @override
  State<LegalChatPage> createState() => _LegalChatPageState();
}

class _LegalChatPageState extends State<LegalChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool showEmojiPicker = false;

  final String userName = "John Doe";
  final String userId = "USER-102938";

  List<_ChatMessage> messages = [
    _ChatMessage(
      text: "Hello 👋 I’m Lexi, your legal assistant.\nHow can I help you today?",
      isBot: true,
    ),
  ];

  final List<String> quickReplies = [
    "Employment Issue",
    "Contract Review",
    "Family Law",
    "Police Matter",
    "Property Dispute",
  ];

  // ───────────────── BOT TRIGGER ─────────────────
  void _triggerBot(String input) {
    String response = "I’ve noted your request. A legal officer will respond shortly.";

    if (input.toLowerCase().contains("employment")) {
      response = "⚖️ Employment Law:\nWere you unfairly dismissed or underpaid?";
    } else if (input.toLowerCase().contains("contract")) {
      response = "📄 Contract Review:\nYou may upload your contract for review.";
    } else if (input.toLowerCase().contains("family")) {
      response = "👨‍👩‍👧 Family Law:\nDivorce, custody, or maintenance?";
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        messages.add(_ChatMessage(text: response, isBot: true));
      });
      _scrollToBottom();
    });
  }

  // ───────────────── SEND MESSAGE ─────────────────
  void _sendMessage({String? text}) {
    final msg = text ?? _messageController.text.trim();
    if (msg.isEmpty) return;

    setState(() {
      messages.add(_ChatMessage(text: msg, isBot: false));
      _messageController.clear();
    });

    _scrollToBottom();
    _triggerBot(msg);
  }

  // ───────────────── ATTACH IMAGE ─────────────────
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        messages.add(
          _ChatMessage(
            text: "📎 Image attached",
            isBot: false,
            attachmentPath: image.path,
          ),
        );
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Legal Support",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            Text("$userName • $userId",
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          // ───────── QUICK RESPONSE BUTTONS ─────────
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: quickReplies.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(item),
                    onPressed: () => _sendMessage(text: item),
                  ),
                );
              }).toList(),
            ),
          ),

          // ───────── CHAT AREA ─────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) => _ChatBubble(messages[i]),
            ),
          ),

          // ───────── EMOJI PICKER ─────────
          if (showEmojiPicker)
            SizedBox(
              height: 260,
              child: EmojiPicker(
                onEmojiSelected: (_, emoji) {
                  _messageController.text += emoji.emoji;
                },
              ),
            ),

          // ───────── INPUT BAR ─────────
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () =>
                        setState(() => showEmojiPicker = !showEmojiPicker),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Type your legal question…",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Voice input coming soon 🎤")),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ───────────────── CHAT MODEL ─────────────────
class _ChatMessage {
  final String text;
  final bool isBot;
  final String? attachmentPath;

  _ChatMessage({
    required this.text,
    required this.isBot,
    this.attachmentPath,
  });
}

// ───────────────── CHAT BUBBLE ─────────────────
class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble(this.message);

  @override
  Widget build(BuildContext context) {
    final align = message.isBot ? Alignment.centerLeft : Alignment.centerRight;
    final color = message.isBot ? Colors.white : Colors.blueAccent;

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isBot ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }
}