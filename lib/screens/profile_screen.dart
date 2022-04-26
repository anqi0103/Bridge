import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Bridge'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    // Retrieve the data here
                    child: Text("Profile Screen: Test_User_1",
                        style: Theme.of(context).textTheme.headline6),
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
                  subtitle:
                    const Text('Provide a list of comments here.'),
                )
              )
            ]
          ))
      )
    );
  }
}