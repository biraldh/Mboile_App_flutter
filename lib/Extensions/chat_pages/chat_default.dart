import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/Extensions/chat_pages/chat_page.dart';
import 'package:flutterap/Extensions/chat_pages/user_tile.dart';
import 'package:flutterap/Extensions/chat_service.dart';
import 'package:flutterap/services/firebase_auths.dart';

class chatDefault extends StatelessWidget {
  chatDefault({super.key});

  //chat & auth services
  final ChatService _chatService = ChatService();
  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Users"),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        //return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //building individual List title for user
  Widget _buildUserListItem(
      Map<String, dynamic>? userData, BuildContext context) {
    // Check if userData is not null and contains required fields
    if (userData != null && userData.containsKey("email")) {
      String email = userData["email"] ?? "";
      String uid =
          userData["uid"] ?? email; // Set uid equal to email if it is null

      // Displaying all the users
      return UserTile(
        text: email,
        onTap: () {
          // Tapped on a user -> go to individual chat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: email,
                receiverID: uid,
              ),
            ),
          );
        },
      );
    } else {
      // Handle the case where userData or required fields are null
      return Container();
    }
  }
}
