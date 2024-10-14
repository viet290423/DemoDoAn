import 'package:auth_login_firebase/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> friendsList = [];

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _loadFriendsList();
    }
  }

  Future<void> _loadFriendsList() async {
    try {
      // Lấy thông tin người dùng từ Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('User')
              .doc(currentUser!.email) // Sử dụng email làm ID tài liệu
              .get();

      if (userDoc.exists) {
        List<dynamic> friends = userDoc.data()?['listFriend'] ?? [];
        setState(() {
          friendsList = friends.cast<Map<String, dynamic>>();
        });
      } else {
        debugPrint('Không tìm thấy thông tin người dùng.');
      }
    } catch (e) {
      debugPrint('Lỗi khi lấy danh sách bạn bè: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách bạn bè')),
      body: friendsList.isEmpty
          ? Center(child: Text('Chưa có bạn bè nào.'))
          : ListView.builder(
              itemCount: friendsList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> friend = friendsList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        friend['profile_image'] ?? 'default_profile_image_url'),
                  ),
                  title: Text(friend['username']),
                  subtitle: Text(friend['email']),
                  trailing: IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {
                      // Chuyển đến trang chat với thông tin bạn bè
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(receiverEmail: '', receiverID: '',),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
