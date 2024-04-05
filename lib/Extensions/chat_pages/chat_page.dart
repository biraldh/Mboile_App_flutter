import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/Extensions/chat_service.dart';
import 'package:flutterap/services/firebase_auths.dart';

class ChatPage extends StatelessWidget {
  final String recieverEmail;
  final String receiverID;
  ChatPage({super.key, required this.recieverEmail, required this.receiverID});

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  // Method to delete all messages
  void deleteAllMessages() async {
    await _chatService.deleteAllMessages(receiverID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recieverEmail),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteAllMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _authServices.getUserDetail(_authServices.getCurrentUser()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        String senderID = snapshot.data?['email'] ?? '';
        return StreamBuilder(
          stream: _chatService.getMessages(receiverID, senderID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading..");
            }
            List<DocumentSnapshot> docs = snapshot.data!.docs;

            // Reverse the order of messages
            List<DocumentSnapshot> reversedDocs = List.from(docs.reversed);

            return ListView.builder(
              reverse: true, // Set reverse to true
              itemCount: reversedDocs.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Widget>(
                  future: _buildMessageItem(reversedDocs[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data!;
                    } else {
                      return const SizedBox(); // Placeholder or loading indicator
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Widget> _buildMessageItem(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    Future<User?> currentUser = _authServices.getCurrentUser();
    String currentUserEmail = (await currentUser)?.email ?? '';

    bool isCurrentUser = data['senderEmail'] == currentUserEmail;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          data["message"],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Type a message...',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: Icon(Icons.arrow_upward),
        ),
      ],
    );
  }
}
