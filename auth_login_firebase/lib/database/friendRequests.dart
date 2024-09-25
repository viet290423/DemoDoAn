import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// Lớp dịch vụ lấy yêu cầu kết bạn
class FriendRequestsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lấy danh sách yêu cầu kết bạn
  Future<List<Map<String, dynamic>>> getFriendRequests() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return []; // Nếu không có người dùng hiện tại thì trả về danh sách rỗng

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('FriendRequests')
          .where('receiverUid', isEqualTo: currentUser.uid)
          .get();

      // Chuyển đổi dữ liệu thành danh sách yêu cầu kết bạn
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        return {
          'requestId': doc.id, // ID của yêu cầu kết bạn
          'senderUid': data?['senderUid'] ?? '', // UID của người gửi
          'sendername': data?['sendername'] ?? 'Unknown', // Tên người gửi
          'senderEmail': data?['senderEmail'] ?? 'Unknown', // Email người gửi
          'status': data?['status'] ?? 'pending', // Trạng thái yêu cầu
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching friend requests: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }
}
