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
            headerBuilder: (context, constraints, reqdouble) {
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
                        FaIcon(FontAwesomeIcons.bridgeWater,
                            color: Colors.blue, size: 75),
                        FaIcon(FontAwesomeIcons.bridgeWater,
                            color: Colors.blue, size: 75),
                      ],
                    ),
                  ],
                ),
              );
            },
            providerConfigs: const [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                  clientId:
                      '95176891876-u330m7kctqp2kn0q89pq1a5g0tet3dsj.apps.googleusercontent.com')
            ],
          );
        }

        return HomeScreen(user: snapshot.data!);
      },
    );
  }
}
