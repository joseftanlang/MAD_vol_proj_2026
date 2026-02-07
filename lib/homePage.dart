import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
// import '../accessibility_provider.dart';
import '../components/appBar.dart';
import '../components/drawer.dart';
import '../components/bottomNav.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainApp extends StatefulWidget {
  const TrainApp({super.key});

  @override
  State<TrainApp> createState() => _TrainAppState();
}

class _TrainAppState extends State<TrainApp> {
  final TextEditingController _searchController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  Timer? _speechTimeout;
  bool _isListening = false;
  bool _speechEnabled = false;

  final Map<String, String> categoryRoutes = {
    "Volunteer": "/volunteer",
    "Training": "/training",
    "donation": "/donation",
    "aboutus": "/aboutus",
    "accessibility": "/accessibility",
    "legalservice": "/legalservice",
    "qrcode": "/qrcode",
    "Log Out": "/login",
    "settings": "/settings",
    "Chatbot": "/chatbot",
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) return;

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenMode: ListenMode.confirmation,
    );

    setState(() => _isListening = true);
  }

  Future<void> _stopListening() async {
    _speechTimeout?.cancel();
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _searchController.text = result.recognizedWords;
    });
    _speechTimeout?.cancel();
    if (result.finalResult) {
      _speechTimeout = Timer(const Duration(seconds: 2), () {
        if (_isListening) {
          _stopListening();
          _searchAndNavigate(result.recognizedWords);
        }
      });
    }
  }

  void _searchAndNavigate(String spokenText) {
    final query = spokenText.toLowerCase();

    final Map<String, String> keywordRoutes = {
      "volunteer": "/volunteer",
      "training": "/training",
      "donation": "/donation",
      "about": "/aboutus",
      "accessibility": "/accessibility",
      "legal": "/legalservice",
      "qr": "/qrcode",
      "settings": "/settings",
      "chatbot": "/chatbot",
      "logout": "/login",
    };

    for (final entry in keywordRoutes.entries) {
      if (query.contains(entry.key)) {
        Navigator.pushNamed(context, entry.value);
        debugPrint("Voice matched: ${entry.key}");
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No matching page for: "$spokenText"')),
    );
    debugPrint("No matching page for: $query");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(),
      drawer: DrawerNav(),
      bottomNavigationBar: const AppBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => debugPrint("The train is coming!"),
        child: const Icon(Icons.train),
      ),
      body: ListView(
        children: [
          _welcomeUser(),
          _imageCarousel(),
          _searchBar(),
          _buttonGrid(),
        ],
      ),
    );
  }

  Widget _welcomeUser() {
    return FutureBuilder(
      future: _fetchWelcomeMessage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error loading welcome message'),
          );
        } else {
          // snapshot.data contains your widget
          return snapshot.data as Widget;
        }
      },
    );
  }

  Future<Widget> _fetchWelcomeMessage() async {
    String? username;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Welcome to SP!',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      username = data['username'] ?? 'SP!';
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Welcome back, $username!',
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for opportunities',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _searchAndNavigate(_searchController.text);
                },
              ),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : null,
                ),
                onPressed: _isListening ? _stopListening : _startListening,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageCarousel() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 12),
          Image(image: AssetImage('assets/1vol.jpg')),
          SizedBox(width: 12),
          Image(image: AssetImage('assets/2vol.jpg')),
          SizedBox(width: 12),
          Image(image: AssetImage('assets/3vol.jpg')),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buttonGrid() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_buttonColumn(0), _buttonColumn(categoryRoutes.length ~/ 2)],
      ),
    );
  }

  Widget _buttonColumn(int startIndex) {
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];

    return Column(
      children: List.generate(
        categoryRoutes.length ~/ 2,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              final key = categoryRoutes.keys.elementAt(startIndex + i);
              final route = categoryRoutes[key];
              if (route != null) {
                Navigator.pushNamed(context, route);
              } else {
                debugPrint("No route found for $key");
              }
            },
            // icon: const Icon(Icons.help, color: Colors.white),
            label: Text(
              categoryRoutes.keys.elementAt(startIndex + i),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(130, 130),
              backgroundColor: colors[i % colors.length],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
