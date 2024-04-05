import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterap/Extensions/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverEmail, message) async {
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now(); // Get the current timestamp

    Message newMessage = Message(
      senderID: currentUserEmail,
      senderEmail: currentUserEmail,
      receiverID: receiverEmail,
      message: message,
      timestamp: timestamp,
    );

    List<String> emails = [currentUserEmail, receiverEmail];
    emails.sort();
    String chatRoomID = emails.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userEmail, otherUserEmail) {
    List<String> emails = [userEmail, otherUserEmail];
    emails.sort();
    String chatRoomID = emails.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp', descending: false) // Order by timestamp
        .snapshots();
  }
  Future<void> deleteAllMessages(String receiverEmail) async {
    try {
      final currentUserEmail = _auth.currentUser!.email!;

      // Get the chat room ID
      List<String> emails = [currentUserEmail, receiverEmail];
      emails.sort();
      String chatRoomID = emails.join('_');

      // Get reference to the chat room's messages collection
      final chatRoomRef = _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages");

      // Delete all messages in the chat room
      final messagesSnapshot = await chatRoomRef.get();
      for (final messageDoc in messagesSnapshot.docs) {
        await messageDoc.reference.delete();
      }
    } catch (e) {
      print('Error deleting messages: $e');
      // Handle error as per your application's requirements
    }
  }
}
