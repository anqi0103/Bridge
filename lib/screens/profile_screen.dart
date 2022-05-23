import 'package:bridge/widgets/attribute_form.dart';
import 'package:bridge/widgets/user_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/users.dart';
import '../widgets/user_comments.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  DocumentSnapshot<Users>? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    var currentUser = await Users.getUserCollection()
        .doc(user!.uid)
        .withConverter(
          fromFirestore: Users.fromFirestore,
          toFirestore: (Users user, _) => {},
        )
        .get();

    setState(() {
      this.currentUser = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    signOut() async {
      await _firebaseAuth.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Bridge'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: users
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const UserAuth();
                        } else if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          return displayUserProfile(snapshot, context);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text("Today's comments"),
              UserComments(
                username: currentUser?.data()?.anonymousName,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text("Sign Out"),
        onPressed: () {
          signOut();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const UserAuth()));
        },
      ),
    );
  }

  Column displayUserProfile(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot, BuildContext context) {
    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return Column(
      children: [
        Text("Today's Snapshot", style: Theme.of(context).textTheme.headline4),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Text("Randomized username: ${data['anonymousName']}"),
        Text("Your attribute: ${data['attribute']}"),
        Text("Comment count: ${data['numberComments']}"),
        Text("Vote count: ${data['numberVotes']}"),
        InkWell(
          onTap: () {
            _showMaterialDialog();
          },
          child: const Text(
            "Edit Attribute",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Add Attribute'),
            content: AttributeForm(),
          );
        });
  }
}
