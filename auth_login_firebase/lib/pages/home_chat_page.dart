import 'package:auth_login_firebase/components/my_drawer.dart';
import 'package:auth_login_firebase/components/user_tile.dart';
import 'package:auth_login_firebase/services/auth_service.dart';
import 'package:auth_login_firebase/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeChatPage extends StatelessWidget {
  final String receiverEmail; // Email của người nhận
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  HomeChatPage({super.key, required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail), // Hiển thị email người nhận
        backgroundColor: Colors.grey[200], // Màu nền sáng
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildMessageList(), // Hiển thị danh sách tin nhắn
    );
  }

  // Xây dựng danh sách tin nhắn
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(_authService.getCurrentUser() as String, receiverEmail),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading messages"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Danh sách tin nhắn
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final messageData = doc.data() as Map<String, dynamic>;
            return _buildMessageItem(messageData);
          }).toList(),
        );
      },
    );
  }

  // Xây dựng item tin nhắn
  Widget _buildMessageItem(Map<String, dynamic> messageData) {
    // Kiểm tra người gửi và trả về widget tin nhắn tương ứng
    bool isSender = messageData['senderID'] == _authService.getCurrentUser();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: isSender ? Colors.blueAccent : Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            messageData['message'],
            style: TextStyle(color: isSender ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
