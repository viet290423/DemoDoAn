// import 'package:auth_login_firebase/services/list_friend_service.dart';
// import 'package:flutter/material.dart';


// class ListFriendScreen extends StatefulWidget {
//   @override
//   _ListFriendScreenState createState() => _ListFriendScreenState();
// }

// class _ListFriendScreenState extends State<ListFriendScreen> {
//   final ListFriendService _listFriendService = ListFriendService();
//   List<Map<String, dynamic>> friendRequests = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchFriendRequests();
//   }

//   Future<void> _fetchFriendRequests() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       friendRequests = await _listFriendService.getFriendRequests();
//     } catch (error) {
//       print('Error fetching friend requests: $error');
//       // Xử lý lỗi ở đây, ví dụ: hiển thị thông báo cho người dùng
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   void _confirmRequest(String requestId) async {
//     try {
//       await _listFriendService.confirmFriendRequest(requestId);
//       _fetchFriendRequests(); // Cập nhật danh sách sau khi xác nhận
//     } catch (error) {
//       print('Error confirming friend request: $error');
//       // Xử lý lỗi ở đây
//     }
//   }

//   void _deleteRequest(String requestId) async {
//     try {
//       await _listFriendService.deleteFriendRequest(requestId);
//       _fetchFriendRequests(); // Cập nhật danh sách sau khi xóa
//     } catch (error) {
//       print('Error deleting friend request: $error');
//       // Xử lý lỗi ở đây
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Yêu cầu kết bạn'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : friendRequests.isEmpty
//               ? Center(child: Text('Không có yêu cầu kết bạn nào'))
//               : ListView.builder(
//                   itemCount: friendRequests.length,
//                   itemBuilder: (context, index) {
//                     final request = friendRequests[index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: request['profile_image'] != null ? NetworkImage(request['profile_image']) : null,
//                       ),
//                       title: Text(request['username'] ?? 'Unknown'),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.check),
//                             onPressed: () {
//                               _confirmRequest(request['_id']); // Sử dụng `_id` để xác nhận
//                             },
//                             color: Colors.green,
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.close),
//                             onPressed: () {
//                               _deleteRequest(request['_id']); // Sử dụng `_id` để từ chối
//                             },
//                             color: Colors.red,
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:auth_login_firebase/pages/chat_page.dart';
import 'package:auth_login_firebase/services/list_friend_service.dart';
import 'package:flutter/material.dart';

class ListFriendScreen extends StatefulWidget {
  @override
  _ListFriendScreenState createState() => _ListFriendScreenState();
}

class _ListFriendScreenState extends State<ListFriendScreen> {
  final ListFriendService _listFriendService = ListFriendService();
  List<Map<String, dynamic>> friendRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriendRequests();
  }

  Future<void> _fetchFriendRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      friendRequests = await _listFriendService.getFriendRequests();
    } catch (error) {
      print('Lỗi khi tải yêu cầu kết bạn: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải yêu cầu kết bạn')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void _confirmRequest(String requestId) async {
    try {
      await _listFriendService.confirmFriendRequest(requestId);
      _fetchFriendRequests(); // Cập nhật danh sách sau khi xác nhận
    } catch (error) {
      print('Lỗi khi xác nhận yêu cầu kết bạn: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xác nhận yêu cầu')),
      );
    }
  }

  void _deleteRequest(String requestId) async {
    try {
      await _listFriendService.deleteFriendRequest(requestId);
      _fetchFriendRequests(); // Cập nhật danh sách sau khi xóa
    } catch (error) {
      print('Lỗi khi xóa yêu cầu kết bạn: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa yêu cầu')),
      );
    }
  }

  void _openChat(String email, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(receiverEmail: email, receiverID: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yêu cầu kết bạn'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : friendRequests.isEmpty
              ? Center(child: Text('Không có yêu cầu kết bạn nào.'))
              : ListView.builder(
                  itemCount: friendRequests.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> request = friendRequests[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            request['profile_image'] ?? 'default_profile_image_url'),
                      ),
                      title: Text(request['username']),
                      subtitle: Text(request['email']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => _confirmRequest(request['id']),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => _deleteRequest(request['id']),
                          ),
                        ],
                      ),
                      onTap: () => _openChat(request['email'], request['id']),
                    );
                  },
                ),
    );
  }
}
