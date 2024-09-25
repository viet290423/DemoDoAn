import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendRequestsService {
  // Lấy các yêu cầu kết bạn của người dùng hiện tại
  Future<List<Map<String, dynamic>>> getFriendRequests() async {
    try {
      // Lấy UID của người dùng hiện tại
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        debugPrint('Người dùng hiện tại không tồn tại.');
        return [];
      }

      // Lấy các yêu cầu kết bạn từ collection FriendRequests
      DocumentSnapshot<Map<String, dynamic>> requestsDoc =
          await FirebaseFirestore.instance
              .collection('FriendRequests')
              .doc(currentUser.uid)
              .get();

      if (!requestsDoc.exists) {
        debugPrint('Không có yêu cầu kết bạn.');
        return [];
      }

      List<dynamic> requests = requestsDoc.data()?['requests'] ?? [];

      // Trả về danh sách yêu cầu kết bạn
      return requests.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Lỗi khi lấy yêu cầu kết bạn: $e');
      return [];
    }
  }

  // Chấp nhận yêu cầu kết bạn
  Future<void> acceptFriendRequest(Map<String, dynamic> friendRequest) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        debugPrint('Người dùng hiện tại không tồn tại.');
        return;
      }

      String currentUserEmail = currentUser.email ?? '';

      // Xóa yêu cầu kết bạn khỏi FriendRequests sau khi chấp nhận
      await FirebaseFirestore.instance
          .collection('FriendRequests')
          .doc(currentUserEmail)
          .update({
        'requests': FieldValue.arrayRemove([friendRequest])
      });

      // Thêm người bạn vào danh sách bạn bè (có thể lưu vào một collection Friends hoặc thực hiện logic khác)
      await FirebaseFirestore.instance
          .collection('Friends')
          .doc(currentUserEmail)
          .update({
        'friends': FieldValue.arrayUnion([friendRequest])
      });

      debugPrint('Đã chấp nhận yêu cầu kết bạn.');
    } catch (e) {
      debugPrint('Lỗi khi chấp nhận yêu cầu kết bạn: $e');
    }
  }

  // Xóa yêu cầu kết bạn
  Future<void> declineFriendRequest(Map<String, dynamic> friendRequest) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        debugPrint('Người dùng hiện tại không tồn tại.');
        return;
      }

      String currentUserEmail = currentUser.email ?? '';

      // Xóa yêu cầu kết bạn khỏi FriendRequests
      await FirebaseFirestore.instance
          .collection('FriendRequests')
          .doc(currentUserEmail)
          .update({
        'requests': FieldValue.arrayRemove([friendRequest])
      });

      debugPrint('Đã xóa yêu cầu kết bạn.');
    } catch (e) {
      debugPrint('Lỗi khi xóa yêu cầu kết bạn: $e');
    }
  }
}
