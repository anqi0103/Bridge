import 'package:cloud_firestore/cloud_firestore.dart';

class ArchivedComments {
  String comment;
  String username;
  int rating;
  String promptID;

  ArchivedComments({required this.comment, required this.username, required this.rating, required this.promptID});

  factory ArchivedComments.fromFirestore(DocumentSnapshot document) {
    return ArchivedComments(
      comment: document['comment'],
      username: document['username'],
      rating: document['rating'],
      promptID: document['promptID'],
    );
  }
}
