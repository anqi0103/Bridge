import 'package:bridge/models/comments.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          var currentUser = FirebaseAuth.instance.currentUser?.uid;
          Comments newComment = Comments(
            comment: commentBody.body,
            rating: 0,
            username: currentUser!,
            commentID: ''
          );
          newComment.addComment(widget.id);
          Navigator.of(context).pop();
        }
      },
      child: const Text('Save'),
    );
  }


  Widget bodyField(){
    return Expanded(
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        expands: true,
        maxLines: null,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder()
        ),
        onSaved: (newValue) {
          commentBody.body = newValue!;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Text is required';
          }
          return null;
        },
      ),
    );
  }

}
