import 'package:cloud_firestore/cloud_firestore.dart';

class Prompts {
  String prompt;
  int numberTimesDisplayed;
  int numberComments;
  String promptID;

  Prompts({
    required this.prompt, 
    required this.numberTimesDisplayed, 
    required this.numberComments,
    required this.promptID
  });

  factory Prompts.fromFirestore(Map<dynamic, dynamic> document) {
    return Prompts(
      prompt: document['prompt'],
      numberTimesDisplayed: document['numberTimesDisplayed'],
      numberComments: document['numberComments'],
      promptID: ''
    );
  }
}
