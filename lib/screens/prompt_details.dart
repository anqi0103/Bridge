import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bridge/models/comments.dart';
import 'package:bridge/models/prompts.dart';
import 'package:bridge/screens/profile_screen.dart';
import 'package:bridge/widgets/comment_layout.dart';
import 'package:bridge/widgets/new_comment_form.dart';

class PromptDetailScreen extends StatefulWidget {
  final Prompts prompt;

  const PromptDetailScreen({ Key? key, required this.prompt }) : super(key: key);

  @override
  State<PromptDetailScreen> createState() => _PromptDetailScreenState();
}

class _PromptDetailScreenState extends State<PromptDetailScreen> {
  late String id = widget.prompt.promptID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Bridge'),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
            child: const Icon(Icons.account_circle_rounded),
          ),
        )],
      ),
      body: commentsStreamBuilder(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMaterialDialog();
        },
        label: const Text('Add Comment'),
        icon: const Icon(Icons.comment),
      ),
    );
  }

  Widget commentsStreamBuilder (BuildContext context) {
    final Stream<QuerySnapshot> _commentsStream = 
      FirebaseFirestore.instance.collection('prompts').doc(id).collection('comments').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _commentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        var commentsList =
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>; 
            var temp = Comments.fromFirestore(data);
            temp.commentID = document.id;
            return temp;
          }).toList();
          
        commentsList.sort((a, b) => b.rating.compareTo(a.rating));            
      
        return Column(
          children: [
            // Doing it this way fixes the prompt header so it can always be seen.
            // Alternately we could have it unfixed, and it would disappear as we
            // scroll...
            Container(
              height: 100,
              color: Colors.blue[800],
              child: Center(child: 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.prompt.prompt, 
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)
                  )
                )
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: commentsList.length,
                itemBuilder: (context, index) {
                  var comment = commentsList[index];
                  return CommentLayout(
                    promptID: id,
                    comment: comment 
                  );
                },
              ),
            ),
          ],
        );
      }
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: .8,
            child: AlertDialog(
              title: const Text('New Comment'),
              content: NewCommentForm(id: id), 
            ),
          );
        });
  }
}
