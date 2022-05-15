import 'package:bridge/models/prompts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../screens/prompt_details.dart';

class UserComments extends StatelessWidget {
  final String? username;

  const UserComments({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (username == null) {
      return const Text("Loading");
    }

    return StreamBuilder<QuerySnapshot<Comment>>(
      stream: FirebaseFirestore.instance
          .collectionGroup("comments")
          .where("username", isEqualTo: username)
          .orderBy("rating")
          .withConverter(
            fromFirestore: Comment.fromFirestore,
            toFirestore: (Comment comment, _) => comment.toFirestore(),
          )
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Comment>> snapshot,
      ) {
        if (snapshot.hasError) {
          print(snapshot.error);

          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text("Error: ${snapshot.error}"),
          );
        }

        if (snapshot.hasData) {
          return SizedBox(
            height: 2300,
            child: ListView.builder(
              // import the comments by user
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var comment = snapshot.data!.docs.elementAt(index).data();
                return ListTile(
                  title: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(comment.comment ?? "Null"),
                      ),
                    ],
                  ),
                  onTap: () async {
                    // await _addPromptReferenceToComment();
                    var prompt = await comment.prompt
                        ?.withConverter(
                          fromFirestore: (snapshot, options) =>
                              Prompts.fromFirestore(
                                  snapshot.data() as Map<String, dynamic>,
                                  snapshot.id),
                          toFirestore: (Prompts prompt, _) => {},
                        )
                        .get();

                    if (prompt != null && prompt.data() != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PromptDetailScreen(
                            prompt: prompt.data()!,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        }

        return const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text("Loading"),
        );
      },
    );
  }

  _addPromptReferenceToComment() async {
    var prompts = await FirebaseFirestore.instance.collection('prompts').get();

    for (var i = 0; i < prompts.size; i++) {
      var prompt = prompts.docs.elementAt(i).reference;
      var comments = await prompt.collection('comments').get();

      for (var i = 0; i < comments.size; i++) {
        var comment = comments.docs.elementAt(i).reference;
        await comment.update({'prompt': prompt});
      }
    }
  }
}
