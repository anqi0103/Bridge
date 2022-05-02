import 'dart:math';
import 'package:bridge/screens/profile_screen.dart' as bridge_profile_screen;
import 'package:bridge/models/prompts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './prompt_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool isLoading = true;
  List<Prompts> promptList = [];

  @override
  void initState() {
    super.initState();
    generatePromptsIfNone();
  }

  void generatePromptsIfNone() async {
    var now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day);

    var resultTempPrompts = await FirebaseFirestore.instance
        .collection('tempPrompts')
        .where('timestamp', isEqualTo: startOfDay)
        .get();

    DocumentReference<Map<String, dynamic>> tempPromptRef;
    if (resultTempPrompts.docs.isEmpty) {
      tempPromptRef =
          await FirebaseFirestore.instance.collection('tempPrompts').add({
        'timestamp': startOfDay,
      });

      var promptsResult =
          await FirebaseFirestore.instance.collection('prompts').get();
      var length = promptsResult.docs.length;
      var random = Random();
      var selectedDocs = [];
      for (var i = 0; i < 5; i++) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc;
        do {
          doc = promptsResult.docs.elementAt(random.nextInt(length));
        } while (selectedDocs.contains(doc));
        selectedDocs.add(doc);
        await tempPromptRef
            .collection('prompts')
            .add({'prompt': doc.reference});
      }
    } else {
      tempPromptRef = resultTempPrompts.docs.elementAt(0).reference;
    }

    var prompts = await tempPromptRef.collection('prompts').get();
    List<Prompts> promptData = [];
    for (var prompt in prompts.docs) {
      var d = await (prompt.data()['prompt'] as DocumentReference).get();
      var p = Prompts.fromFirestore(d.data() as Map<String, dynamic>, d.id);
      promptData.add(p);
    }

    setState(() {
      isLoading = false;
      promptList = promptData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Text("Loading...");
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Today's Prompts"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const bridge_profile_screen.ProfileScreen(),
                  ),
                ),
                child: const Icon(Icons.account_circle_rounded),
              ),
            )
          ],
        ),
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
                            child: Text(
                                prompt.numberComments.toString() + ' replies'),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PromptDetailScreen(prompt: prompt),
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
    }
  }
}
