import 'package:bridge/models/attributes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttributeBody {
  String body = '';
}

class AttributeForm extends StatefulWidget {
  const AttributeForm({Key? key }) : super(key: key);

  @override
  State<AttributeForm> createState() => _AttributeFormState();
}

class _AttributeFormState extends State<AttributeForm> {
  final formKey = GlobalKey<FormState>();
  final attributeBody = AttributeBody();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            bodyField(),
            saveButton(context),
          ],
        ),
      )
    );
  }

  Widget saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          var userID = FirebaseAuth.instance.currentUser?.uid;
          Attributes newAttribute = Attributes(
            attributeName: '', 
            userID: userID!,

          );
          newAttribute.addAttributeToUserModel(userID, attributeBody.body);
          Navigator.of(context).pop();
        }
      },
      child: const Text('Save'),
    );
  }


  Widget bodyField(){
    return TextFormField(
        expands: false,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter your attribute',
        ),
        onSaved: (newValue) {
          attributeBody.body = newValue!;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Text is required';
          } else if (value.length > 10) {
            return 'Error: Must be <= 10 characters';
          } else if (value.contains(' ')) {
            return 'Error: Must be one word (no spaces)';
          }
          return null;
        },
    );
  }

}
