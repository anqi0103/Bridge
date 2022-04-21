import 'package:bridge/screens/home_screen_prompts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class UserAuth extends StatelessWidget {
  const UserAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
        {
          return SignInScreen(
            headerBuilder: (context, constraints, reqdouble) {
              return Expanded(
                child: Column(
                children: const [
                  Text('Bridge',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 75,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    indent: 50,
                    endIndent: 50,
                  )
                ])
              );
            },
            providerConfigs: const [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                clientId: '95176891876-u330m7kctqp2kn0q89pq1a5g0tet3dsj.apps.googleusercontent.com'
              ),
              FacebookProviderConfiguration(
                clientId: '1054097828822917',
              ),
            ],
          );
        }
        return const HomeScreen();
      },
    );
  }
}