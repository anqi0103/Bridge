import 'package:bridge/screens/profile_screen.dart' as bridge_profile_screen;
import 'package:bridge/models/prompts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './prompt_details.dart';

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

        var promptList =
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>; 
              var temp = Prompts.fromFirestore(data);
              temp.promptID = document.id;
              return temp;
            }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Today's Prompts"),
            actions: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const bridge_profile_screen.ProfileScreen())),
              child: const Icon(Icons.account_circle_rounded),
            ),
            )],
          ),
          // Need to rewrite here using ListView and map the prompts
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: promptList.length,
                  itemBuilder: (context, index) {
                    var prompt = promptList[index];
                    return ListTile(
                      title: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ), 
                            child: Text(prompt.prompt),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(prompt.numberComments.toString() + ' replies'),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PromptDetailScreen(
                            prompt: prompt
                          ),
                        ),
                      ),
                    );
                  }, 
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
