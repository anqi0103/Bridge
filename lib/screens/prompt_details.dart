import 'package:flutter/material.dart';

class PromptDetailScreen extends StatefulWidget {
  final List comments;

  const PromptDetailScreen({ Key? key, required this.comments }) : super(key: key);

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
      ),
      body: ListView.builder(
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: .5), 
                borderRadius: BorderRadius.circular(5)),
              title: Text(widget.comments[index]),
            ),
          );
        },
      ),
    );
  }
}
