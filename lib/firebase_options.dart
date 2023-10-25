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
    apiKey: 'AIzaSyCbV6uwE_VerESbIOssnz6TgfFvq57iKGs',
    appId: '1:883391824274:web:f6bce26d890c573a8a414b',
    messagingSenderId: '883391824274',
    projectId: 'screenusagedata',
    authDomain: 'screenusagedata.firebaseapp.com',
    storageBucket: 'screenusagedata.appspot.com',
    measurementId: 'G-82WHGL4HWM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLpFJR4TQ2A9hEZLj7g0YHJZjaIkSA4Hg',
    appId: '1:883391824274:android:b94f185e764df5c68a414b',
    messagingSenderId: '883391824274',
    projectId: 'screenusagedata',
    storageBucket: 'screenusagedata.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfaV95KsX8rPmquS3YIpjFtQRxCIPqWkc',
    appId: '1:883391824274:ios:a365ba880d5c8fc68a414b',
    messagingSenderId: '883391824274',
    projectId: 'screenusagedata',
    storageBucket: 'screenusagedata.appspot.com',
    iosBundleId: 'com.example.dataGetter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfaV95KsX8rPmquS3YIpjFtQRxCIPqWkc',
    appId: '1:883391824274:ios:a365ba880d5c8fc68a414b',
    messagingSenderId: '883391824274',
    projectId: 'screenusagedata',
    storageBucket: 'screenusagedata.appspot.com',
    iosBundleId: 'com.example.dataGetter',
  );
}
