import 'package:auth_login_firebase/database/addFriend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Lớp dịch vụ tìm kiếm bạn bè
class SearchFriendService {
  // Tìm kiếm người dùng theo email hoặc username
  Future<List<Map<String, dynamic>>> searchUser(String searchTerm) async {
    try {
      // Tìm kiếm qua email trong Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('email', isEqualTo: searchTerm)
          .get();

      // Nếu không tìm thấy qua email thì tìm kiếm qua username
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('username', isEqualTo: searchTerm)
            .get();
      }

      // Chuyển đổi dữ liệu thành danh sách người dùng
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return {
          'uid': data?['uid'] ?? '', // UID của người dùng
          'username': data?['username'] ?? 'Unknown', // Tên người dùng hoặc 'Unknown'
          'profile_image': data?['profile_image'] ?? 'default_profile_image_url', // Ảnh đại diện hoặc URL mặc định
        };
      }).toList();
    } catch (e) {
      // In lỗi ra console nếu có vấn đề
      debugPrint('Error searching user: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  // Gọi dịch vụ gửi yêu cầu kết bạn từ AddFriendService
  Future<void> sendFriendRequest(String friendUid) async {
    AddFriendService().sendFriendRequest(friendUid);
  }
}
