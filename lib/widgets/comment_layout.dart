import 'package:bridge/models/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentLayout extends StatelessWidget {
  final Comments comment;
  final String promptID;

  const CommentLayout({Key? key, required this.comment, required this.promptID}) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              Expanded(child: Text(comment.username)),
              FutureBuilder(future: getUser(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (comment.username == snapshot.data) {
                    return InkWell(
                      child: const Icon(Icons.delete, color: Colors.red,),
                      onTap: () => comment.deleteComment(promptID)
                    );
                  }
                } 
                return const SizedBox(height: 0, width: 0,); 
              }
              ),
              const Icon(Icons.star),
              const Icon(Icons.badge),
            ]
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(comment.comment),
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                child: Icon(Icons.arrow_circle_up, color: Colors.blue[800],),
                onTap: () => comment.upvoteComment(promptID, comment.commentID),
              ),
              InkWell(
                child: Icon(Icons.arrow_circle_down, color: Colors.amber[800],),
                onTap: () => comment.downvoteComment(promptID, comment.commentID)
              )
            ],
          ),
        ]
      ),
    );
  }

  Future<String> getUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var uid = FirebaseAuth.instance.currentUser?.uid;
    var userRef = await users.doc(uid).get();
    return userRef.get('anonymousName').toString();
  }
}
