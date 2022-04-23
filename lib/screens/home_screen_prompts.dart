import 'package:bridge/models/prompts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import './prompt_details.dart';
import './test_model_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  Widget build(BuildContext context) {
    print("db test: current user ID: " + user.uid);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bridge'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text("Today's Prompts",
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ),
              ),
              // Need to rewrite here using ListView and map the prompts
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black, width: .5),
                        borderRadius: BorderRadius.circular(5)),
                    subtitle:
                        const Text('Here\'s a comment that says some stuff.'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PromptDetailScreen(
                                  comments: List<String>.generate(
                                    100,
                                    (i) => 'Item $i',
                                  ),
                                  prompt: Prompts(
                                      // Hard-coded this with random mock data for now.
                                      // We'll get it connected to Firebase at some point.
                                      prompt: 'What do you think the world '
                                          'will look like in 300 years?',
                                      numberComments: 100,
                                      numberTimesDisplayed: 3),
                                ))),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: const Text("7 replies"),
                ),
              ),
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
                          builder: (context) => const SignOutButton())),
                  child: const Text('View Models')),
            ],
          )),
        ));
  }
}
