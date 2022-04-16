import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String comment;
  String username;
  int rating;
  String promptID;

  Comments({required this.comment, required this.username, required this.rating, required this.promptID});

  factory Comments.fromFirestore(DocumentSnapshot document) {
    return Comments(
      comment: document['comment'],
      username: document['username'],
      rating: document['rating'],
      promptID: document['promptID'],
    );
  }
}
