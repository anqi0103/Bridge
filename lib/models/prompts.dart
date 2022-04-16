import 'package:cloud_firestore/cloud_firestore.dart';

class Prompts {
  String prompt;
  int numberTimesDisplayed;
  int numberComments;

  Prompts({required this.prompt, required this.numberTimesDisplayed, required this.numberComments});

  factory Prompts.fromFirestore(DocumentSnapshot document) {
    return Prompts(
      prompt: document['prompt'],
      numberTimesDisplayed: document['numberTimesDisplayed'],
      numberComments: document['numberComments']
    );
  }
}
