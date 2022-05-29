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

  String getUserID() => FirebaseAuth.instance.currentUser?.uid as String;

  DocumentReference getDocRef(String collection, String docID) => 
    FirebaseFirestore.instance.collection(collection).doc(docID);

  CollectionReference getSubcollectionRef(String collection1, String docID, String collection2) => 
    FirebaseFirestore.instance.collection(collection1).doc(docID).collection(collection2);

  Future<void> addComment(String id) async {
    final uid = getUserID();
    // final databaseReference = FirebaseFirestore.instance;
    final prompt = await FirebaseFirestore.instance.collection('prompts').doc(id).get();
    final subcollectionRef = getSubcollectionRef('prompts', id, 'comments');
    subcollectionRef
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
    getDocRef('prompts', id)
        .update({"numberComments": FieldValue.increment(1)});
    getDocRef('users', uid)
        .update({
          "numberComments": FieldValue.increment(1),
          "lastCommentTime": DateTime.now()});
  }

  void upvoteComment(String promptID, String commentID) async {
    // Increment comment rating value
    DocumentReference docRef = getSubcollectionRef('prompts', promptID, 'comments')
        .doc(commentID);
    DocumentSnapshot doc = await docRef.get();
    final uid = getUserID();
    // only upvote if current user hasn't already
    if (!doc['raters'].contains(uid)) {
      docRef.update({
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
    DocumentReference docRef = getSubcollectionRef('prompts', promptID, 'comments')
        .doc(commentID);
    DocumentSnapshot doc = await docRef.get();
    final uid = getUserID();
    // only downvote if user hasn't already
    if (!doc['raters'].contains(uid)) {
      docRef.update({
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
    final comments = getSubcollectionRef('prompts', pid, 'comments');
    final uid = getUserID();
    getDocRef('users', uid)
      .update({"numberComments": FieldValue.increment(-1)});

    return comments
        .doc(commentID)
        .delete()
        .then((value) => log("Comment Deleted"))
        .catchError((error) => log("Failed to delete comment: $error"));
  }
}
