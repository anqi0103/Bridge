import 'package:bridge/models/comments.dart';
import 'package:flutter/material.dart';

class CommentLayout extends StatelessWidget {
  Comments comment;

  CommentLayout({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              Expanded(child: Text(comment.username)),
              const Icon(Icons.star),
              const Icon(Icons.badge),
            ]
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(comment.comment),
                ),
              ],
            ),
          ),
          Row(
            children: const [
              Icon(Icons.arrow_circle_up),
              Icon(Icons.arrow_circle_down)
            ],
          ),
        ]
      ),
    );
  }
}
