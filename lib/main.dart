import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// Pages
import 'pages/login.dart';
import 'pages/settings.dart';
import 'pages/singup.dart';
import 'pages/donation.dart';
import 'pages/about_us.dart';
import 'pages/accessibility_page.dart';
import 'pages/LegalChatService.dart';
import 'pages/qr_code.dart';
import 'pages/training.dart';
import 'pages/volunteer.dart';
import 'pages/chatbot_page.dart';
import 'pages/location_track.dart';

// Provider
import 'accessibility_provider.dart';

// Home Page
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AccessibilityProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final accessibilityProvider = Provider.of<AccessibilityProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Train App',
      locale: Provider.of<AccessibilityProvider>(context).language,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.light,
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
        textTheme: Provider.of<AccessibilityProvider>(context).textVariations,
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
        textTheme: Provider.of<AccessibilityProvider>(context).textVariations,
      ),
      themeMode: accessibilityProvider.darkMode,
      home: LoginPage(),
      routes: {
        '/home': (_) => const TrainApp(),
        '/login': (_) => LoginPage(),
        '/settings': (_) => SettingPage(),
        '/signup': (_) => SignUpPage(),
        '/donation': (_) => DonationPage(),
        '/aboutus': (_) => AboutUsPage(),
        '/accessibility': (_) => AccessibilityPage(),
        '/legalservice': (_) => LegalChatPage(),
        '/qrcode': (_) => QRCodePage(),
        '/training': (_) => TrainingPage(),
        '/volunteer': (_) => VolunteerPage(),
        '/chatbot': (_) => ChatbotPage(),
        '/locationtrack': (_) => const LocationPage(),
      },
    );
  }
}






















// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:final_project_flutter/accessibility_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';

// //this is to import the relevant files (import pages)
// import 'firebase_options.dart';
// import '../pages/login.dart';
// import '../pages/settings.dart';
// import '../pages/singup.dart';
// import '../pages/donation.dart';
// import '../pages/about_us.dart';
// import '../pages/accessibility_page.dart';
// import '../pages/LegalChatService.dart';
// import '../pages/qr_code.dart';
// import '../pages/training.dart';
// import '../pages/volunteer.dart';

// //this is for the packages component file that we have created
// import 'package:final_project_flutter/components/appBar.dart';
// import 'package:final_project_flutter/components/drawer.dart';
// import 'package:final_project_flutter/components/bottomNav.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(
//   ChangeNotifierProvider(
//     create: (_) => AccessibilityProvider(),
//     child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Train App',
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: ThemeMode.system, // or use provider
//       home:  TrainApp(),
//       routes: {
//         '/login': (_) => LoginPage(),
//         '/settings': (_) => SettingPage(),
//         '/signup': (_) => SignUpPage(),
//         '/donation': (_) => DonationPage(),
//         '/aboutus': (_) => AboutUsPage(),
//         '/accessibility': (_) => AccessibilityPage(),
//         '/legalservice': (_) => LegalChatPage(),
//         '/qrcode': (_) => QRCodePage(),
//         '/training': (_) => TrainingPage(),
//         '/volunteer': (_) => VolunteerPage(),
//       },
//     ),
//   ),
// );
// }




// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: DonationPage(),
//   ));
  
// }