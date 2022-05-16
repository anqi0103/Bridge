import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? comment;
  final String? username;
  final int? rating;
  final DocumentReference? prompt;

  Comment({
    required this.comment,
    required this.username,
    required this.rating,
    this.prompt,
  });

  Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : comment = snapshot['comment'],
        username = snapshot['username'],
        rating = snapshot['rating'],
        prompt = snapshot['prompt'];

  Map<String, dynamic> toFirestore() {
    return {
      if (comment != null) "comment": comment,
      if (username != null) "username": username,
      if (rating != null) "rating": rating,
    };
  }
}
