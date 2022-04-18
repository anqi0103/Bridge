import 'package:cloud_firestore/cloud_firestore.dart';

class Attributes {
  String attributeName;
  String username;

  Attributes({required this.attributeName, required this.username});

  factory Attributes.fromFirestore(DocumentSnapshot document) {
    return Attributes(
      attributeName: document['attributeName'],
      username: document['username']
    );
  }

  void addAttribute() {
    getAttributeCollection().add({
      'attributeName' : attributeName,
      'username' : username,
    });
  }

  static CollectionReference getAttributeCollection() {
    return FirebaseFirestore.instance.collection('attributes');
  }
}
