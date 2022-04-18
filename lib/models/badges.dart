import 'package:cloud_firestore/cloud_firestore.dart';

class Badges {
  String badgeName;
  String reference;
  List<String> usersEarned;

  Badges({required this.badgeName, required this.reference, required this.usersEarned});

  factory Badges.fromFirestore(DocumentSnapshot document) {
    return Badges(
      badgeName: document['badgeName'],
      reference: document['reference'],
      usersEarned: document['usersEarned']
    );
  }
}
