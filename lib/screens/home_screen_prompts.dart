import 'package:bridge/models/prompts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import './prompt_details.dart';
import './test_model_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('prompts').limit(5).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }
        if (snapshot.data == null) {
          return const Text("snapshot.data is null");
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Today's Prompts"),
          ),
          // Need to rewrite here using ListView and map the prompts
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ), 
                          child: Text(snapshot.data!.docs.elementAt(index)["prompt"]),
                        ),
                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: const Text("7 replies"),
                          ),
                        ),
                      ],
                    ),
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
                            prompt:
                                snapshot.data!.docs.elementAt(index)["prompt"],
                            numberComments: 100,
                            numberTimesDisplayed: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TestModelScreen(),
                  ),
                ),
                child: const Text('View Models'),
              ),
              const SignOutButton(),
            ],
          ),
        );
      },
    );
  }
}
