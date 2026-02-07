import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBTlkcHRIOWFrMHH85avDIBmn4AC0P5MlM",
    authDomain: "mad-proj-vol-app.firebaseapp.com",
    databaseURL: "https://mad-proj-vol-app-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "mad-proj-vol-app",
    storageBucket: "mad-proj-vol-app.appspot.com", // fix .app -> .appspot.com
    messagingSenderId: "1049970791173",
    appId: "1:1049970791173:web:6df339eee6640b2ac3dd6c",
    measurementId: "G-E07EZ4FTCS",
  );

  static const FirebaseOptions android = web; // For testing, same as web
  static const FirebaseOptions ios = web;
}