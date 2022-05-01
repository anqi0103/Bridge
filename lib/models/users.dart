import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';

class Users {
  String email;
  String attribute;
  int rating;
  int numberComments;
  int numberVotes;
  String anonymousName;

  Users({
    this.email = '', 
    this.attribute = '', 
    this.rating = 0, 
    this.numberComments = 0, 
    this.numberVotes = 0, 
    this.anonymousName = ''
    });

  factory Users.fromFirestore(DocumentSnapshot document) {
    return Users(
      email: document['email'],
      attribute: document['attribute'],
      rating : document['rating'],
      numberComments: document['numberComments'],
      numberVotes: document['numberVotes'],
      anonymousName: document['anonymousName']
    );
  }

  static CollectionReference getUserCollection() {
    return FirebaseFirestore.instance.collection('users');
  }

  static String createAnonymousName() {
    final words = <String>[];

    generateWordPairs().take(1).forEach((word) => words.add(word.asPascalCase));
    return words.first;
  }
}