import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAMzhZvT55vHqVkCJ8wOz80M23fwKbaE-I",
        authDomain: "bridge-7759a.firebaseapp.com",
        projectId: "bridge-7759a",
        storageBucket: "bridge-7759a.appspot.com",
        messagingSenderId: "95176891876",
        appId: "1:95176891876:web:a3b5cd275257037c2a3bf1",
        measurementId: "G-SLPJ0K93BC"),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  runApp(const App(title: 'Bridge'));
}
