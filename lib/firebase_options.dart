// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC37qDoS8RKx9NyoGjC7xbn3cdTFCzphAs',
    appId: '1:1010013586962:web:ffca25a3b3663324d87acb',
    messagingSenderId: '1010013586962',
    projectId: 'chatapp-bb123',
    authDomain: 'chatapp-bb123.firebaseapp.com',
    storageBucket: 'chatapp-bb123.appspot.com',
    measurementId: 'G-TWYBZ9CMFL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnF1GLNnFbVoQpPSeJ4aW_uABWkFUjMCw',
    appId: '1:1010013586962:android:4e932a8e0d2bad44d87acb',
    messagingSenderId: '1010013586962',
    projectId: 'chatapp-bb123',
    storageBucket: 'chatapp-bb123.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAT09qLowShdKjqZsvfYWuh_UJg4LvAQBU',
    appId: '1:1010013586962:ios:f9b5920c4fc78eacd87acb',
    messagingSenderId: '1010013586962',
    projectId: 'chatapp-bb123',
    storageBucket: 'chatapp-bb123.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAT09qLowShdKjqZsvfYWuh_UJg4LvAQBU',
    appId: '1:1010013586962:ios:f4b063b2ac1690efd87acb',
    messagingSenderId: '1010013586962',
    projectId: 'chatapp-bb123',
    storageBucket: 'chatapp-bb123.appspot.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
