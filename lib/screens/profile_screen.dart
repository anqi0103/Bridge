import 'package:bridge/widgets/user_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
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
                    child: FutureBuilder<DocumentSnapshot>(
                        future: users
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const UserAuth();
                          } else if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Column(children: [
                              Text("Today's Snapshot",
                                  style: Theme.of(context).textTheme.headline4),
                              const Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                  "Randomized username: ${data['anonymousName']}"),
                              Text("Your attribute: ${data['attribute']}"),
                              Text("Comment count: ${data['numberComments']}"),
                              Text("Vote count: ${data['numberVotes']}"),
                              InkWell(
                                  onTap: () {},
                                  child: const Text("Edit Attribute",
                                      style: TextStyle(color: Colors.blue))),
                            ]);
                          }
                        }),
                  ),
                ),
              ),
              const SizedBox(height: 200),
              const Text("Today's comments"),
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black, width: .5),
                        borderRadius: BorderRadius.circular(5)),
                    subtitle: const Text('Provide a list of comments here.'),
                  )),
            ],
          ),
        )),
        floatingActionButton: ElevatedButton(
          child: const Text("Sign Out"),
          onPressed: () {
            signOut();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserAuth()));
          },
        ));
  }
}
