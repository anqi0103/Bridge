import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/attributes.dart';

class TestModelScreen extends StatefulWidget {
  const TestModelScreen({Key? key}) : super(key: key);

  @override
  State<TestModelScreen> createState() => _TestModelScreenState();
}

class _TestModelScreenState extends State<TestModelScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference attributes = FirebaseFirestore.instance.collection('attributes');

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Bridge'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: const Icon(Icons.account_circle_rounded),
            ),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: attributes.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Text('Getting information');
            }
            return ListView(
              children:
              snapshot.data!.docs.map((key) {
                return Card(
                  child: ListTile(
                    title: Text('Attribute Model ID: ' + key.id),
                    subtitle: Text(key['attributeName'] + '|' + key['username']),
                  ),
                );
              }).toList(),
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Attributes attribute = Attributes(attributeName: "testAttrAdded", username: "testUserAdded");
        attribute.addAttribute();
      },
      
      child: const Text('Add'),
      )
    );
  }
}
