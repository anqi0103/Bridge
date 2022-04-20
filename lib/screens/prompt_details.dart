import 'package:bridge/models/comments.dart';
import 'package:bridge/models/prompts.dart';
import 'package:bridge/widgets/comment_layout.dart';
import 'package:bridge/widgets/new_comment_form.dart';
import 'package:flutter/material.dart';

class PromptDetailScreen extends StatefulWidget {
  final List comments;
  final Prompts prompt;

  const PromptDetailScreen({ Key? key, required this.comments, required this.prompt }) : super(key: key);

  @override
  State<PromptDetailScreen> createState() => _PromptDetailScreenState();
}

class _PromptDetailScreenState extends State<PromptDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Bridge'),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            // onTap: (() => Navigator.push(context, MaterialPageRoute(builder: ProfileScreen()))),
            child: const Icon(Icons.account_circle_rounded),
          ),
        )],
      ),
      body: Column(
        children: [
          // Doing it this way fixes the prompt header so it can always be seen.
          // Alternately we could have it unfixed, and it would disappear as we
          // scroll...
          Container(
            height: 100,
            color: Colors.greenAccent,
            child: Center(child: 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.prompt.prompt, 
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6
                )
              )
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                return CommentLayout(
                  comment: Comments(
                    // Hard-coded this as well, temporarily. 
                    comment:  'Space, the final frontier. These are the voyages '
                              'of the starship Enterprise. It\'s continuing mission'
                              ', to explore strange new worlds. To seek out new...',
                    rating: 50,
                    username: 'anon_$index',
                    promptID: 'abc_$index'
                  )  
                );
                // return CommentLayout(comment: CommentsList[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMaterialDialog();
        },
        label: const Text('Add Comment'),
        icon: const Icon(Icons.comment),
      ),
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const FractionallySizedBox(
            heightFactor: .8,
            child: AlertDialog(
              title: Text('New Comment'),
              content: NewCommentForm(), 
            ),
          );
        });
  }
}
