// this is for all the packages dependecies
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_1/accessibility_provider.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

//this is to import the relevant files (import pages)
import 'firebase_options.dart';
import '../pages/login.dart';
import '../pages/settings.dart';
import '../pages/singup.dart';
import '../pages/donation.dart';
import '../pages/about_us.dart';
import '../pages/accessibility_page.dart';
import '../pages/legal_service.dart';
import '../pages/qr_code.dart';
import '../pages/training.dart';
import '../pages/volunteer.dart';

//this is for the packages component file that we have created
import 'package:project_1/components/bottomNav.dart';
import 'package:project_1/components/drawer.dart';
import  'package:project_1/components/appBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AccessibilityProvider(),
      child: const TrainApp(),
  ));
}

/* ───────────────────────── APP ROOT ───────────────────────── */

class TrainApp extends StatefulWidget {
  const TrainApp({super.key});
  

  @override
  State<TrainApp> createState() => _TrainAppState();
}

class _TrainAppState extends State<TrainApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /* ───────── SEARCH + SPEECH ───────── */
  final TextEditingController _searchController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  bool _isListening = false;

  /* ───────── DATA ───────── */
  final List<String> mainAppSquareWidget = [
    "Migrant",
    "Children",
    "Elderly",
    "Environmental",
    "Health",
    "Education",
    "Animal",
    "Community",
    "Arts",
    "Sports",
  ];

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

    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() => _isListening = true);
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _searchController.text = result.recognizedWords;
    });
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      debugPrint("Searching for: $query");
      // TODO: Firestore / filtering logic
    }
  }

  /* ───────────────────────── UI ───────────────────────── */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Train App',
      theme: ThemeData(
        // colorScheme: Colorsc
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.amber,
          inactiveTrackColor: Color.fromRGBO(153, 117, 112, 1),
          thumbColor: Colors.red,
          valueIndicatorColor: Color.fromRGBO(153, 117, 112, 1),
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white60,
          )
        ),
        textTheme: AccessibilityProvider.textVariations,
        ),
      darkTheme: ThemeData(
        colorScheme:  ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        sliderTheme: SliderThemeData(
          activeTrackColor: Color.fromRGBO(153, 117, 112, 1),
          inactiveTrackColor: Colors.amber,
          thumbColor: Colors.red,
          valueIndicatorColor: Color.fromRGBO(153, 117, 112, 1),
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white70
          )
        ),
      ),
      themeMode: Provider.of<AccessibilityProvider>(context).darkMode,
      routes: {
        '/login': (_) => LoginPage(),
        '/settings': (_) => SettingPage(),
        '/signup': (_) => SignUpPage(),
        '/donation': (_) => DonationPage(),
        '/aboutus': (_) => AboutUsPage(),
        '/accessibility': (_) => AccessibilityPage(),
        '/legalservice': (_) => LegalServicePage(),
        '/qrcode': (_) => QRCodePage(),
        '/training': (_) => TrainingPage(),
        '/volunteer': (_) => VolunteerPage(),
        '/home': (_) => TrainApp(),
      },
      home: Scaffold(
        appBar: const AppAppBar(),

        /* ───────── BODY ───────── */
        body: ListView(
          children: [
            _imageCarousel(),
            _searchBar(),
            _buttonGrid(),
          ],
        ),

        /* ───────── DRAWER ───────── */
        drawer: DrawerNav(),

        /* ───────── BOTTOM NAV ───────── */
        bottomNavigationBar: const AppBottomNav(),

        floatingActionButton: FloatingActionButton(
          onPressed: () => debugPrint("🚆 The train is coming!"),
          child: const Icon(Icons.train),
        ),

        // bottomSheet: Container(
        //   height: 30,
        //   color: Colors.blueAccent,
        //   alignment: Alignment.center,
        //   child: const Text(
        //     '© 2026 Train App',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
      ),
    );
  }

  /* ───────────────────────── WIDGETS ───────────────────────── */

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for volunteer opportunities',
          // hintStyle: const TextStyle(fontSize: ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _search,
              ),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : null,
                ),
                onPressed:
                    _isListening ? _stopListening : _startListening,
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
        children: const [
          Image(image: AssetImage('../lib/assets/1vol.jpg'), width: 350),
          Image(image: AssetImage('../lib/assets/2vol.jpg'), width: 350),
          Image(image: AssetImage('../lib/assets/3vol.jpg'), width: 350),
          
        ],
      ),
    );
  }

  Widget _buttonGrid() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buttonColumn(0),
          _buttonColumn(mainAppSquareWidget.length ~/ 2),
        ],
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
        mainAppSquareWidget.length ~/ 2,
        // below is the item builder function where we define each button and its properties to be used in the grid
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              print("Pressed ${mainAppSquareWidget[startIndex + i]}");
            },
            icon: const Icon(Icons.help, color: Colors.white),
            label: Text(
              mainAppSquareWidget[startIndex + i],
              style: const TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(180, 180),
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


  // Drawer _drawer() {
  //   return Drawer(
  //     child: ListView(
  //       children: [
  //         const DrawerHeader(
  //           decoration: BoxDecoration(color: Colors.blue),
  //           child: Text('Navigation Menu',
  //               style: TextStyle(color: Colors.white, fontSize: 24)),
  //         ),
  //         _drawerItem(Icons.login, 'Login', '/login'),
  //         _drawerItem(Icons.settings, 'Settings', '/settings'),
  //         _drawerItem(Icons.person_add, 'Sign Up', '/signup'),
  //         _drawerItem(Icons.record_voice_over, 'Text to Speech', '/tts'),
  //       ],
  //     ),
  //   );
  // }

  // ListTile _drawerItem(IconData icon, String title, String route) {
  //   return ListTile(
  //     leading: Icon(icon),
  //     title: Text(title),
  //     onTap: () =>
  //         navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //       route,
  //       (route) => false,
  //     ),
  //   );
  // }

  // BottomNavigationBar _bottomNav(BuildContext context) {
  //   return BottomNavigationBar(
  //     items: const [
  //       BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
  //       BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  //       BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Sign Up'),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.record_voice_over), label: 'TTS'),
  //     ],
  //     onTap: (i) {
  //       switch (i) {
  //         case 0:
  //           Navigator.pushNamed(context, '/login');
  //           break;
  //         case 1:
  //           Navigator.pushNamed(context, '/settings');
  //           break;
  //         case 2:
  //           Navigator.pushNamed(context, '/signup');
  //           break;
  //         case 3:
  //           Navigator.pushNamed(context, '/tts');
  //           break;
  //       }
  //     },
  //   );
  // }
}
