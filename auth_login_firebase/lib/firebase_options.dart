// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBeCI9nCcItxNMT3WLf83mFe39FDq0KayI',
    appId: '1:849600736150:web:a966cb8b85ea09ebc78bb7',
    messagingSenderId: '849600736150',
    projectId: 'authtutorial-cfc9e',
    authDomain: 'authtutorial-cfc9e.firebaseapp.com',
    storageBucket: 'authtutorial-cfc9e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB22l2qHoRJdbku7csk8OLj3XCsJAZbUvY',
    appId: '1:849600736150:android:a325f8b49bacd4acc78bb7',
    messagingSenderId: '849600736150',
    projectId: 'authtutorial-cfc9e',
    storageBucket: 'authtutorial-cfc9e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9XPAV7GOqrG4EEQ1hsicxx6vf-idp4v4',
    appId: '1:849600736150:ios:2e34ca015db63c5ec78bb7',
    messagingSenderId: '849600736150',
    projectId: 'authtutorial-cfc9e',
    storageBucket: 'authtutorial-cfc9e.appspot.com',
    iosBundleId: 'com.example.authLoginFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9XPAV7GOqrG4EEQ1hsicxx6vf-idp4v4',
    appId: '1:849600736150:ios:2e34ca015db63c5ec78bb7',
    messagingSenderId: '849600736150',
    projectId: 'authtutorial-cfc9e',
    storageBucket: 'authtutorial-cfc9e.appspot.com',
    iosBundleId: 'com.example.authLoginFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeCI9nCcItxNMT3WLf83mFe39FDq0KayI',
    appId: '1:849600736150:web:2e54b51249b3ab2ac78bb7',
    messagingSenderId: '849600736150',
    projectId: 'authtutorial-cfc9e',
    authDomain: 'authtutorial-cfc9e.firebaseapp.com',
    storageBucket: 'authtutorial-cfc9e.appspot.com',
  );
}
