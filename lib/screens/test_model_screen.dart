import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../models/attributes.dart';

class TestModelScreen extends StatefulWidget {
  const TestModelScreen({Key? key}) : super(key: key);

  @override
  State<TestModelScreen> createState() => _TestModelScreenState();
}

class _TestModelScreenState extends State<TestModelScreen> {
  @override
  Widget build(BuildContext context) {
    var attributes = Attributes.getAttributeCollection();

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
        var random = Random();
        var randomNum = random.nextInt(100);
        var randomNum2 = random.nextInt(100);
        Attributes attributeHardCodedExample = Attributes(attributeName: "testAttrAdded"+ randomNum.toString(), username: "testUserAdded" + randomNum2.toString());
        attributeHardCodedExample.addAttribute();
      },
      
      child: const Text('Add'),
      )
    );
  }
}
