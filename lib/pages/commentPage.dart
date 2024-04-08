import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/services/commentService.dart';

class commentPage extends StatefulWidget {
  final String postid;
  final String? user;

  const commentPage({
    Key? key,
    required this.postid,
    required this.user,
  }) : super(key: key);

  @override
  State<commentPage> createState() => _commentPageState();
}

class _commentPageState extends State<commentPage> {
  final commentService cService = commentService();
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: cService.getComments(widget.postid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.white),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Text(
                      "No comments available.",
                      style: TextStyle(color: Colors.white),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var commentData = snapshot.data!.docs[index].data();
                        return CommentItem(
                          commentData: commentData,
                          onReply: () => _showReplyDialog(
                            context,
                            commentData['commentOwner'],
                            commentData['commentId']
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              color: Colors.brown[800],
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width / 1.2,
                      child: TextField(
                        controller: _commentcontroller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a comment',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cService.createComment(
                        widget.user,
                        widget.postid,
                        _commentcontroller.text,

                      );
                    },
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showReplyDialog(BuildContext context, String commentOwner, String commentid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Reply to $commentOwner',
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: _commentcontroller,
            decoration: InputDecoration(
              hintText: 'Enter your reply',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                // Add code to send the reply
                cService.threaded_comment(
                  widget.user,
                  _commentcontroller.text,
                    commentid
                );
                Navigator.of(context).pop();
              },
              child: Text('Reply'),
            ),
          ],
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> commentData;
  final VoidCallback onReply;

  const CommentItem({
    Key? key,
    required this.commentData,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> replies = commentData['replies'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main comment
        ListTile(
          title: Text(
            commentData['comment'],
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            commentData['commentOwner'],
            style: TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            icon: Icon(Icons.reply, color: Colors.white),
            onPressed: onReply,
          ),
        ),
        SizedBox(height: 8),
        // Replies
        if (commentData['thread'] != null && commentData['thread'].isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              commentData['thread'].length,
                  (index) {
                final threadItem = commentData['thread'][index];
                if (threadItem is Map<String, dynamic>) {
                  // Different style for replies
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(8),
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          threadItem['thread'] ?? '', // Use the null-aware operator to handle null values
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                        ),
                        if (threadItem.containsKey('user'))
                          Text(
                            threadItem['user'] ?? '', // Use the null-aware operator to handle null values
                            style: TextStyle(color: Colors.white70),
                          ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink(); // Return an empty widget if threadItem is not a Map
                }
              },
            ),
          ),
        Divider(),
      ],
    );

  }
}

