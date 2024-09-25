import 'package:auth_login_firebase/database/friendRequests.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FriendRequestsService _friendRequestsService = FriendRequestsService();
  List<Map<String, dynamic>> _friendRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendRequests();
  }

  // Lấy yêu cầu kết bạn
  void _fetchFriendRequests() async {
    List<Map<String, dynamic>> requests = await _friendRequestsService.getFriendRequests();
    setState(() {
      _friendRequests = requests;
    });
  }

  // Chấp nhận yêu cầu kết bạn
  void _acceptRequest(String requestId) async {
    // Cập nhật trạng thái yêu cầu kết bạn
    await FirebaseFirestore.instance.collection('FriendRequests').doc(requestId).update({
      'status': 'accepted',
    });
    _fetchFriendRequests(); // Cập nhật lại danh sách
  }

  // Xóa yêu cầu kết bạn
  void _deleteRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('FriendRequests').doc(requestId).delete();
    _fetchFriendRequests(); // Cập nhật lại danh sách
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: ListView.builder(
        itemCount: _friendRequests.length,
        itemBuilder: (context, index) {
          final request = _friendRequests[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(request['profile_image'] ?? ''),
              backgroundColor: Colors.grey,
            ),
            title: Text(request['sendername']),
            subtitle: Text(request['senderEmail']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _acceptRequest(request['requestId']),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _deleteRequest(request['requestId']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
