import 'package:flutter/material.dart';

class CommentBody {
  String? body = '';
}

class NewCommentForm extends StatefulWidget {
  const NewCommentForm({ Key? key }) : super(key: key);

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
          // Send the commentBody.body to Cloud Firestore!
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
          commentBody.body = newValue;
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
