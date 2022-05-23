import 'package:bridge/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/home_screen_prompts.dart';

class UserAuth extends StatelessWidget {
  const UserAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
              sideBuilder: (context, constraints) => drawBridge(),
              headerBuilder: (context, constraints, reqdouble) => drawBridge(),
              providerConfigs: const [
                EmailProviderConfiguration(),
              ]);
        }

        // checks to see if user is a document in Firestore prior to logging in
        final user = FirebaseAuth.instance.currentUser;
        var userRef = Users.getUserCollection().doc(user!.uid);
        userRef.get().then((foundUser) {
          if (foundUser.data() == null) {
            _createUserFirestore(user);
          }
        });

        _randomizeNameDaily(user);

        return const HomeScreen();
      },
    );
  }

  SingleChildScrollView drawBridge() {
    var drawBridgeIcon = const FaIcon(FontAwesomeIcons.bridgeWater,
        color: Colors.blue, size: 75);

    const bridgeText = Center(
      child: Text('bridge',
          style: TextStyle(
            fontSize: 50,
            color: Colors.blue,
          )),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          bridgeText,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Row(children: [
                drawBridgeIcon,
                drawBridgeIcon,
                drawBridgeIcon,
              ]))
            ],
          ),
        ],
      ),
    );
  }

  _randomizeNameDaily(User user) async {
    final currentDay = DateTime.now().day;
    final lastDayFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value.data()!["lastLoginDay"])
        .onError((error, stackTrace) => -1);

    final lastDay = await (lastDayFuture) as int;

    if (currentDay != lastDay) {
      Users.getUserCollection().doc(user.uid).update({
        "anonymousName": Users.createAnonymousName(),
        "lastLoginDay": currentDay
      });
    }
  }

  _createUserFirestore(User user) {
    Users.getUserCollection().doc(user.uid).set({
      "email": user.email,
      "attribute": "",
      "rating": 0,
      "numberComments": 0,
      "numberVotes": 0,
      "anonymousName": Users.createAnonymousName(),
      "lastLoginDay": 1,
      "lastCommentTime": DateTime.fromMillisecondsSinceEpoch(0),
    });
  }
}
