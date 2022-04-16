import 'package:bridge/screens/model_test_screen.dart';
import 'package:bridge/screens/profile_screen.dart';
import 'package:bridge/screens/prompt_details.dart';
import 'package:flutter/material.dart';

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
            // The below button and navigation is just so I could
            // navigate to the Prompt Detail Screen and see it
            // in the simulator.

            // It can/will be replaced obviously with the Home Screen!!

            body: Builder(
              builder: (context) => Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                    ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TestModelScreen())),
                        child: const Text('View Models')),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PromptDetailScreen(
                                  comments: List<String>.generate(
                                      100, (i) => 'Item $i')))),
                      child: const Text('Go To Prompt Detail'),
                    )
                  ])),
            )));
  }
}
