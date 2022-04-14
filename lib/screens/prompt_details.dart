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
            child: const Center(child: Text(
              'The prompt goes here.', 
              style: TextStyle(fontWeight: FontWeight.w700)
            )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: .5), 
                      borderRadius: BorderRadius.circular(5)),
                    title: Text(widget.comments[index]),
                    subtitle: const Text('Here\'s a comment that says some stuff.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
