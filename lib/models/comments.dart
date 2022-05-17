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
    required this.commentID,
  });

  factory Comments.fromFirestore(Map<dynamic, dynamic> document) {
    return Comments(
        comment: document['comment'],
        username: document['username'],
        rating: document['rating'],
        commentID: '');
  }

  Future<void> addComment(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final databaseReference = FirebaseFirestore.instance;
    final prompt = await databaseReference.collection('prompts').doc(id).get();
    databaseReference
        .collection('prompts')
        .doc(id)
        .collection('comments')
        .doc()
        .set(
      {
        'comment': comment,
        'username': username,
        'rating': rating,
        'prompt': prompt.reference,
        'raters':[]
      },
    );
    databaseReference
        .collection('prompts')
        .doc(id)
        .update({"numberComments": FieldValue.increment(1)});
    databaseReference
        .collection('users')
        .doc(uid)
        .update({"numberComments": FieldValue.increment(1)});
    databaseReference
        .collection('users')
        .doc(uid)
        .update({"lastCommentTime": DateTime.now()});
  }

  void upvoteComment(String promptID, String commentID) async {
    // Increment comment rating value
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('prompts')
        .doc(promptID)
        .collection('comments')
        .doc(commentID);
    DocumentSnapshot doc = await documentReference.get();
    final uid = FirebaseAuth.instance.currentUser?.uid as String;
    // only upvote if current user hasn't already
    if (!doc['raters'].contains(uid)) {
      documentReference.update({
        "rating": FieldValue.increment(1),
        "raters": FieldValue.arrayUnion([uid])
      });
      // Increment comment author's rating
      var usr = doc['username'];
      FirebaseFirestore.instance
          .collection('users')
          .where('anonymousName', isEqualTo: usr)
          .get()
          .then((value) {
        var docRef = value.docs[0].reference;
        docRef.update({"numberVotes": FieldValue.increment(1)});
      });
    } else {
      return;
    }

  }

  void downvoteComment(String promptID, String commentID) async {
    // Decrement comment rating value
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('prompts')
        .doc(promptID)
        .collection('comments')
        .doc(commentID);
    DocumentSnapshot doc = await documentReference.get();
    final uid = FirebaseAuth.instance.currentUser?.uid as String;
    // only downvote if user hasn't already
    if (!doc['raters'].contains(uid)) {
      documentReference.update({
        "rating": FieldValue.increment(-1),
        "raters": FieldValue.arrayUnion([uid])
      });
      // Decrement comment author's rating
      var usr = doc['username'];
      FirebaseFirestore.instance
          .collection('users')
          .where('anonymousName', isEqualTo: usr)
          .get()
          .then((value) {
        var docRef = value.docs[0].reference;
        docRef.update({"numberVotes": FieldValue.increment(-1)});
      });

    }
  }

  Future<void> deleteComment(String pid) {
    final comments = FirebaseFirestore.instance
        .collection('prompts')
        .doc(pid)
        .collection('comments');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"numberComments": FieldValue.increment(-1)});

    return comments
        .doc(commentID)
        .delete()
        .then((value) => log("Comment Deleted"))
        .catchError((error) => log("Failed to delete comment: $error"));
  }
}
