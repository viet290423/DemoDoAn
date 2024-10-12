// import 'package:auth_login_firebase/components/my_drawer.dart';
// import 'package:auth_login_firebase/components/my_list_title.dart';
// import 'package:auth_login_firebase/components/search_friend.dart';
// import 'package:auth_login_firebase/components/user_tile.dart';
// import 'package:auth_login_firebase/database/firestore.dart';
// import 'package:auth_login_firebase/pages/chat_page.dart';
// import 'package:auth_login_firebase/services/auth_service.dart';
// import 'package:auth_login_firebase/services/chat_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class HomeChatPage extends StatelessWidget {
//   HomeChatPage({super.key});

//   // chat & auth serviece
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();

//   // firestore access
//   final FirestoreDatabase database = FirestoreDatabase();

//   Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String userEmail) {
//     return FirebaseFirestore.instance.collection('User').doc(userEmail).snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       forceMaterialTransparency: true,
//   //       foregroundColor: Colors.black,
//   //       centerTitle: true,
//   //       title: const Text(
//   //         "Home Chat",
//   //         style: TextStyle(
//   //           fontSize: 24,
//   //           fontWeight: FontWeight.bold,
//   //         ),
//   //       ),
//   //       backgroundColor: Colors.transparent,
//   //       actions: [
//   //         IconButton(
//   //           icon: const Icon(Icons.search),
//   //           onPressed: () {
//   //             showSearch(
//   //               context: context,
//   //               delegate: FriendSearchDelegate(), // Sử dụng lớp FriendSearchDelegate
//   //             );
//   //           },
//   //         ),
//   //       ],
//   //     ),
//   //     drawer: const MyDrawer(),
//   //     body: SafeArea(
//   //       child: Column(
//   //         children: [
            

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home chat page"),
//         backgroundColor:  Colors.transparent,
//         foregroundColor:  Colors.grey,
//         elevation: 0,
//       ),
//       drawer:  const MyDrawer(),
//       body: _buildUserList(),
//     );

//   //           // Hiển thị danh sách người dùng
//   //           Expanded(
//   //             flex: 1, // Dành 1 phần cho danh sách người dùng
//   //             child: _buildUserList(),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   // build a list of user except for the current logged in user
//   Widget _buildUserList() {
//     return StreamBuilder(
//       stream: _chatService.getUsersStream(),
//       builder: (context, snapshot) {
//         // errors
//         if (snapshot.hasError) {
//           return const Text("Error");
//         }

//         //loading
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text("Loading..");
//         }

//         // return list view
//         return ListView(
//           children: snapshot.data!
//               .map<Widget>((userData) => _buildUserListItem(userData, context))
//               .toList(),
//         );
//       },
//     );
//   }

//   // build individual list tile for user
//   Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
//     // display all users except the current user
//     if (userData["email"] != _authService.getCurrentUser()) {
//       return UserTile(
//         text: userData["email"],
//         onTap: () {
//           // tapped on a user except the current user
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ChatPage(
//                 receiverEmail: userData["email"],
//                 receiverID: '',
//               ),
//             ),
//           );
//         },
//       );
//     } else {
//       return Container();
//     }
//   }
// }


// }


// import 'package:auth_login_firebase/components/my_drawer.dart';
// import 'package:auth_login_firebase/components/user_tile.dart';
// import 'package:auth_login_firebase/services/auth_service.dart';
// import 'package:auth_login_firebase/services/chat_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'chat_page.dart';

// class HomeChatPage extends StatelessWidget {
//   HomeChatPage({super.key});

//   // Chat và Auth service
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Chat Page"),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.grey,
//         elevation: 0,
//       ),
//       drawer: const MyDrawer(),
//       body: _buildUserList(),
//     );
//   }

//   /// build a list of user except for the current logged in user
// Widget _buildUserList() {
//   return StreamBuilder<QuerySnapshot>(
//     stream: _chatService.getUsersStream(), // Stream từ Firestore
//     builder: (context, snapshot) {
//       // Xử lý lỗi
//       if (snapshot.hasError) {
//         return const Center(child: Text("Đã xảy ra lỗi!"));
//       }

//       // Đang tải dữ liệu
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       // Nếu không có dữ liệu
//       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//         return const Center(child: Text("Không có người dùng."));
//       }

//       // Trả về danh sách người dùng
//       return ListView(
//         children: snapshot.data!.docs
//             .map<Widget>((doc) => _buildUserListItem(doc.data() as Map<String, dynamic>, context))
//             .toList(),
//       );
//     },
//   );
// }


//   // Xây dựng từng mục người dùng trong danh sách
//   Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
//     String currentUserEmail = _authService.getCurrentUser()?.email ?? '';

//     // Hiển thị tất cả người dùng trừ người dùng hiện tại
//     if (userData["email"] != currentUserEmail) {
//       return UserTile(
//         text: userData["email"],
//         onTap: () {
//           // Điều hướng đến ChatPage với email của người nhận
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ChatPage(
//                 receiverEmail: userData["email"],
//                 receiverID: userData["uid"], // Đảm bảo lấy đúng ID của người dùng
//               ),
//             ),
//           );
//         },
//       );
//     } else {
//       return Container(); // Không hiển thị gì nếu là người dùng hiện tại
//     }
//   }
// }

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
