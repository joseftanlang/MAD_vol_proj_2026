// firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBTlkcHRIOWFrMHH85avDIBmn4AC0P5MlM",
    authDomain: "mad-proj-vol-app.firebaseapp.com",
    projectId: "mad-proj-vol-app",
    storageBucket: "mad-proj-vol-app.appspot.com",
    messagingSenderId: "1049970791173",
    appId: "1:1049970791173:web:6df339eee6640b2ac3dd6c",
    measurementId: "G-E07EZ4FTCS",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBTlkcHRIOWFrMHH85avDIBmn4AC0P5MlM",
    projectId: "mad-proj-vol-app",
    storageBucket: "mad-proj-vol-app.appspot.com",
    messagingSenderId: "1049970791173",
    appId: "1:1049970791173:android:XXXXXXXXXXXX",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBTlkcHRIOWFrMHH85avDIBmn4AC0P5MlM",
    projectId: "mad-proj-vol-app",
    storageBucket: "mad-proj-vol-app.appspot.com",
    messagingSenderId: "1049970791173",
    appId: "1:1049970791173:ios:XXXXXXXXXXXX",
    iosBundleId: "com.example.app",
  );
}
