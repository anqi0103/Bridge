import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comments {
  String comment;
  String username;
  int rating;
  String commentID;

  Comments({
    required this.comment, 
    required this.username, 
    required this.rating,
    required this.commentID
  });

  factory Comments.fromFirestore(Map<dynamic, dynamic> document) {
    return Comments(
      comment: document['comment'],
      username: document['username'],
      rating: document['rating'],
      commentID: ''
    );
  }

  void addComment(String id) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection('prompts')
      .doc(id)
      .collection('comments')
      .doc()
      .set({
        'comment' : comment,
        'username' : username,
        'rating': rating,
      });
    databaseReference.collection('prompts').doc(id).update({"numberComments": FieldValue.increment(1)});
    databaseReference.collection('users').doc(uid).update({"numberComments": FieldValue.increment(1)});
  }

  void upvoteComment(String promptID, String commentID) {
    final databaseReference = FirebaseFirestore.instance;
    databaseReference
      .collection('prompts')
      .doc(promptID)
      .collection('comments')
      .doc(commentID)
      .update({"rating": FieldValue.increment(1)});
  }

  void downvoteComment(String promptID, String commentID) {
    final databaseReference = FirebaseFirestore.instance;
    databaseReference
      .collection('prompts')
      .doc(promptID)
      .collection('comments')
      .doc(commentID)
      .update({"rating": FieldValue.increment(-1)});
  }

  Future<void> deleteComment(String pid) {
    final comments = FirebaseFirestore.instance.collection('prompts').doc(pid).collection('comments');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).update({"numberComments": FieldValue.increment(-1)});

    return comments
      .doc(commentID)
      .delete()
      .then((value) => log("Comment Deleted"))
      .catchError((error) => log("Failed to delete comment: $error"));
  }

}
