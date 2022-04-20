import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_screen_prompts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            const Padding(
              padding: EdgeInsets.only(top: 140, bottom: 40),
              child: SizedBox(
                width: 200,
                height: 200,
                child: DecoratedBox (
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                )
              ),
            ),
            const Center(
              child: SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration (
                    icon: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                    hintText: "username",
                  )
                ),
              ),
            ),
            const Center(
              child: SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration (
                    icon: Icon(
                      Icons.lock_sharp,
                      color: Colors.blue,
                    ),
                    hintText: "password",
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                child: Center(
                  child: ElevatedButton(
                    child: const SizedBox(
                      width: 75,
                      child: Center(
                        child: Text("login")),
                    ),
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen()
                      )
                    ), 
                  ),
                ),
              ),
            ),
            Center(
              child: InkWell(
                child: const Text('forgot password?',
                style: TextStyle(color: Color.fromARGB(199, 4, 18, 95))),
                onTap: () {},
              )
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Divider(
                color: Colors.black,
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text('login with'),
              )
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: TextButton(
                    child: const FaIcon(FontAwesomeIcons.google),
                  onPressed: () {},
                  )
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: TextButton(
                    child: const FaIcon(FontAwesomeIcons.facebook),
                  onPressed: () {},
                  )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: InkWell(
                  child: const Text('sign-up',
                  style: TextStyle(color: Color.fromARGB(199, 4, 18, 95))),
                  onTap: () {},
                )
              ),
            ),
          ]
        )
      ),
    );
  }
}
