import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';

class Users {
  String email;
  String attribute;
  int rating;
  int numberComments;
  int numberVotes;
  String anonymousName;
  DateTime lastCommentTime;
  int lastLoginDay;

  final DateTime initializedDateTime = DateTime.fromMillisecondsSinceEpoch(0);

  Users({
    this.email = '',
    this.attribute = '',
    this.rating = 0,
    this.numberComments = 0,
    this.numberVotes = 0,
    this.anonymousName = '',
    this.lastLoginDay = 1,
    DateTime? lastCommentTime,
  }) : lastCommentTime =
            lastCommentTime ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory Users.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return Users(
        email: snapshot['email'],
        attribute: snapshot['attribute'],
        rating: snapshot['rating'],
        numberComments: snapshot['numberComments'],
        numberVotes: snapshot['numberVotes'],
        anonymousName: snapshot['anonymousName'],
        lastLoginDay: snapshot['lastLoginDay'],
        lastCommentTime: DateTime.fromMillisecondsSinceEpoch(
            snapshot['lastCommentTime'].millisecondsSinceEpoch));
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
