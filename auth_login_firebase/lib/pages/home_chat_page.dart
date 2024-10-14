import 'package:auth_login_firebase/components/my_drawer.dart';
import 'package:auth_login_firebase/components/user_tile.dart';
import 'package:auth_login_firebase/services/auth_service.dart';
import 'package:auth_login_firebase/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class HomeChatPage extends StatelessWidget {
  HomeChatPage({super.key});

  // Chat và Auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Chat Page"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: _buildUserList(),
    );
  }

  /// build a list of user except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // Xử lý lỗi
        if (snapshot.hasError) {
          return const Center(child: Text("Đã xảy ra lỗi!"));
        }

        // Đang tải dữ liệu
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Nếu không có dữ liệu
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Không có người dùng."));
        }

        // Trả về danh sách người dùng
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }


  // Xây dựng từng mục người dùng trong danh sách
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    String currentUserEmail = _authService.getCurrentUser()?.email ?? '';

    // Hiển thị tất cả người dùng trừ người dùng hiện tại
    if (userData["email"] != currentUserEmail) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          // Điều hướng đến ChatPage với email của người nhận
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"], // Đảm bảo lấy đúng ID của người dùng
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Không hiển thị gì nếu là người dùng hiện tại
    }
  }
}

