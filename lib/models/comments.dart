import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String comment;
  String username;
  int rating;
  // String promptID;

  Comments({required this.comment, required this.username, required this.rating});

  factory Comments.fromFirestore(DocumentSnapshot document) {
    return Comments(
      comment: document['comment'],
      username: document['username'],
      rating: document['rating'],
    );
  }

  void addComment() {
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection('prompts')
      .doc('gESp48pyblhRawOSobJP')
      .collection('comments')
      .doc()
      .set({
        'comment' : comment,
        'username' : username,
        'rating': rating,
      });
  }

}
