import 'package:flutter/material.dart';
import './screens/home_screen_prompts.dart';

class App extends StatelessWidget {
  final String title;

  const App({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bridge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Bridge'),
          ),
          body: 
            const HomeScreen(),
      )
    );
  }
}
