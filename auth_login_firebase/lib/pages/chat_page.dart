import 'package:auth_login_firebase/components/chat_bubble.dart';
import 'package:auth_login_firebase/services/auth_service.dart';
import 'package:auth_login_firebase/components/my_textfield.dart';
import 'package:auth_login_firebase/services/auth_service.dart';
import 'package:auth_login_firebase/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_drawer.dart';
import '../components/chat_bubble.dart';

class ChatPage  extends StatelessWidget {

  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    });


  // text controller

  final TextEditingController _messageController = TextEditingController();


  //chat & auth service

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();


  // send message
  void sendMessage() async {
    //if there os something inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(receiverID, _messageController.text);
    }

    // clear text controller
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor:  Colors.transparent,
        foregroundColor:  Colors.grey,
        elevation: 0,
        ),

        body: Column(children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
      //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

      // loading

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loaidng..");
        }

      // return list view
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildmessageItem(doc)).toList(),


        );
    },
    );
  }

  // build message item
  Widget _buildmessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


    // ís ccurrent user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    // align message to the right if sender is the current user , otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ChatBubble(
                message: data["message"],
                isCurrentUser: isCurrentUser,
                )
            ],
      ),
    );
  }

  // build message input

  Widget _buildUserInput() {
    return Row(
      children: [
          // textfield should take up most of the sapce
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),

          // send button
          Container(
            decoration: const BoxDecoration(
              color:  Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward,
              color:  Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
