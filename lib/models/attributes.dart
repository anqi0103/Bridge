import 'package:cloud_firestore/cloud_firestore.dart';

class Attributes {
  String attributeName;
  String userID;

  Attributes({required this.attributeName, required this.userID});

  factory Attributes.fromFirestore(DocumentSnapshot document) {
    return Attributes(
      attributeName: document['attributeName'],
      userID: document['userID']
    );
  }


  void addAttributeToUserModel(String userID, String newAttribute) {
    FirebaseFirestore.instance.collection('users')
      .doc(userID)
      .update({
        'attribute' : newAttribute,
      });
  }

  static CollectionReference getAttributeCollection() {
    return FirebaseFirestore.instance.collection('attributes');
  }
}
