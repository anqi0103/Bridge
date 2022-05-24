import 'package:bridge/widgets/user_auth.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final String title;

  const App({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bridge',
        theme: ThemeData(
          colorSchemeSeed: Colors.blueAccent,
          brightness: Brightness.light,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepOrange)
        ),
        home: const Scaffold(
          body: UserAuth(),
        ));
  }
}
