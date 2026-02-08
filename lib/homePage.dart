import 'package:final_project_flutter/accessibility_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';
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
    syncAccessibilityWithDatabase();
  }
  void syncAccessibilityWithDatabase() async {
    if (AccessibilityProvider.accessibilitySynced) {
      print("Info already synced!!");
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    // Used a powerful firestore method: .set() which creates if field not found and updates if field is found
    if (user != null) {
      try {
        DocumentSnapshot docs = await FirebaseFirestore.instance
            .collection('accessibility')
            .doc(user.uid)
            .get();
        if (docs.exists) {
          final data = docs.data() as Map<String, dynamic>;
          rebuildUI(data);
          
          AccessibilityProvider.data = data;
          AccessibilityProvider.accessibilitySynced = true;
        }
      } catch (err) {
        print("Document not made yet!!");
      }
    } else {
      print("User not logged in!!");
    }
  }
  void rebuildUI(Map data){
    final accessibility = Provider.of<AccessibilityProvider>(context, listen: false);    
    accessibility.changeFontSize(data["fontSize"]);
    (data["darkMode"]) ? accessibility.changeContrast(ThemeMode.dark) : accessibility.changeContrast(ThemeMode.light);
    (data["language"] == "English") ? accessibility.changeLanguage(Locale('en')): accessibility.changeLanguage(Locale('zh'));
    
    return;
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
      SnackBar(content: Text(AppLocalizations.of(context)!.noMatchingPage(spokenText), style: Theme.of(context).textTheme.bodyMedium,)),
    );
    debugPrint("No matching page for: $query");
  }
  String _getCategoryLabel(String key) {
    switch (key) {
      case "Volunteer":
        return AppLocalizations.of(context)!.categoryVolunteer;
      case "Training":
        return AppLocalizations.of(context)!.categoryTraining;
      case "donation":
        return AppLocalizations.of(context)!.categoryDonation;
      case "aboutus":
        return AppLocalizations.of(context)!.categoryAboutUs;
      case "accessibility":
        return AppLocalizations.of(context)!.categoryAccessibility;
      case "legalservice":
        return AppLocalizations.of(context)!.categoryLegalService;
      case "qrcode":
        return AppLocalizations.of(context)!.categoryQrCode;
      case "Log Out":
        return AppLocalizations.of(context)!.categoryLogout;
      case "settings":
        return AppLocalizations.of(context)!.categorySettings;
      case "Chatbot":
        return AppLocalizations.of(context)!.categoryChatbot;
      default:
        return key;
    }
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
            child: Text(AppLocalizations.of(context)!.welcomeLoadError, style: Theme.of(context).textTheme.bodyMedium,),
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
          AppLocalizations.of(context)!.welcomeDefault,
          style: Theme.of(context).textTheme.headlineMedium,
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
        AppLocalizations.of(context)!.welcomeBack(username!),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchOpportunities,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
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
              _getCategoryLabel(categoryRoutes.keys.elementAt(startIndex + i)),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white
              ),
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
