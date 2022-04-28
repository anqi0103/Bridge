import 'package:bridge/models/users.dart';
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
              headerBuilder: (context, constraints, reqdouble) {
                return drawBridge();
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
              ]);
        }

        // checks to see if user is a document in Firestore prior to logging in
        final user = FirebaseAuth.instance.currentUser;
        var userRef = Users.getUserCollection().doc(user!.uid);
        userRef.get().then((foundUser) {
          if (foundUser.data() == null) {
            _createUserFirestore();
          }
        });
        return HomeScreen(user: snapshot.data!);
      },
    );
  }

  SingleChildScrollView drawBridge() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Center(
            child: Text('bridge',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.blue,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: FaIcon(FontAwesomeIcons.bridgeWater,
                    color: Colors.blue, size: 75),
              ),
              FaIcon(
                FontAwesomeIcons.bridgeWater,
                color: Colors.blue,
                size: 75,
              ),
              FaIcon(FontAwesomeIcons.bridgeWater,
                  color: Colors.blue, size: 75),
            ],
          ),
        ],
      ),
    );
  }

  _createUserFirestore() {
    final user = FirebaseAuth.instance.currentUser;
    Users.getUserCollection().doc(user!.uid).set({
      "email": user.email,
      "attribute": "",
      "rating": 0,
      "numberComments": 0,
      "numberVotes": 0,
      "anonymousName": Users.createAnonymousName()
    });
  }


}
