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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAMzhZvT55vHqVkCJ8wOz80M23fwKbaE-I',
    appId: '1:95176891876:web:a3b5cd275257037c2a3bf1',
    messagingSenderId: '95176891876',
    projectId: 'bridge-7759a',
    authDomain: 'bridge-7759a.firebaseapp.com',
    storageBucket: 'bridge-7759a.appspot.com',
    measurementId: 'G-SLPJ0K93BC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgDN4TuM2LIJWBdmEJxYfv5h4xYExLSw4',
    appId: '1:95176891876:android:a553ad29ced6ae712a3bf1',
    messagingSenderId: '95176891876',
    projectId: 'bridge-7759a',
    storageBucket: 'bridge-7759a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBf_wUboh4ozRHJ37asfxIL-jWel19tbVQ',
    appId: '1:95176891876:ios:026e845a743fe0562a3bf1',
    messagingSenderId: '95176891876',
    projectId: 'bridge-7759a',
    storageBucket: 'bridge-7759a.appspot.com',
    androidClientId: '95176891876-6oesgma61u0l8od8c7sbklv3ib9ca438.apps.googleusercontent.com',
    iosClientId: '95176891876-49mmupo3nk65guj8pgmd4edu8a8pndse.apps.googleusercontent.com',
    iosBundleId: 'com.example.bridge',
  );
}
