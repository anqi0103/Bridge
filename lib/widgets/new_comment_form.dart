import 'package:bridge/models/comments.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CommentBody {
  String body = '';
}

class NewCommentForm extends StatefulWidget {
  final String id;

  const NewCommentForm({ required this.id, Key? key }) : super(key: key);

  @override
  State<NewCommentForm> createState() => _NewCommentFormState();
}

class _NewCommentFormState extends State<NewCommentForm> {
  final formKey = GlobalKey<FormState>();
  final commentBody = CommentBody();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: Column(
        children: [
          bodyField(),
          const SizedBox(height: 8.0),
          saveButton(context),
        ],
      )
    );
  }

  Widget saveButton(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          var uid = FirebaseAuth.instance.currentUser?.uid;
          var userRef = await users.doc(uid).get();      
          Comments newComment = Comments(
            comment: commentBody.body,
            rating: 0,
            username: userRef.get('anonymousName').toString(),
            commentID: ''
          );
          newComment.addComment(widget.id);
          Navigator.of(context).pop();
        }
      },
      child: const Text('Save'),
    );
  }

  Widget bodyField() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Expanded(
      child: StreamBuilder<DocumentSnapshot>(
        stream:
            users.doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                Map<String, dynamic> data = 
                    snapshot.data!.data() as Map<String, dynamic>;
                final DateTime lastCommentTime = 
                    (data['lastCommentTime']).toDate();
                DateTime currentTime = DateTime.now();
                int differenceTime =
                    currentTime.difference(lastCommentTime).inSeconds;

                return TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  maxLines: null,
                  autofocus: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onSaved: (newValue) {
                    commentBody.body = newValue!;
                  },
                  validator: (value) {
                    int charLength = 360 - value!.length;
                    setState(() {
                      currentTime = DateTime.now();
                      differenceTime =
                        currentTime.difference(lastCommentTime).inSeconds;
                    charLength = 360 - value.length;
                    });
                    if (value == null || value.isEmpty) {
                      return 'Text is required';
                    } else if (differenceTime < 5) {
                      int timeLeft = (differenceTime - 5).abs();
                      return 'Please wait $timeLeft seconds and try again';
                    } else if (value.length > 360) {
                      charLength = (360 - value.length).abs();
                      return 'Character length exceeded by $charLength';
                    }
                    return null;
                  },
                );
              }
            }));
  }
}
