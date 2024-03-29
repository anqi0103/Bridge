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
        toolbarHeight: 75.0,
        leading: const BackButton(),
        title: const Text(
          'Bridge',
          style: TextStyle(fontFamily: 'AlfaSlabOne'),
        ),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async { 
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              setState(() {});
            },
            child: const Icon(Icons.account_circle_rounded),
          ),
        )],
      ),
      body: commentsStreamBuilder(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMaterialDialog();
        },
        label: const Text(
          'Add Comment',
          style: TextStyle(fontFamily: 'AlfaSlabOne')
        ),
        icon: const Icon(Icons.comment),
      ),
    );
  }

  Widget commentsStreamBuilder(BuildContext context) {
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
            Container(
              color: Colors.indigo[100],
              height: 150,
              child: Center(child: 
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Text(
                    widget.prompt.prompt, 
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.indigo[800],
                      fontWeight: FontWeight.w600)
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
            title: Center(
              child: Text(
                'New Comment',
                style: TextStyle(
                  fontFamily: 'AlfaSlabOne',
                  color: Colors.deepOrange[800])
              ),
            ),
            content: NewCommentForm(id: id), 
          ),
        );
      });
  }
}
