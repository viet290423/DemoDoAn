import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriendService {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Hàm gửi yêu cầu kết bạn
  Future<void> sendFriendRequest(String friendUid) async {
    try {
      // Lấy UID của người dùng hiện tại (người gửi yêu cầu kết bạn)
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      debugPrint("UID người gửi yêu cầu: $currentUserUid");

      if (currentUserUid == null) {
        debugPrint("Không tìm thấy UID của người dùng hiện tại.");
        return;
      }

      // Truy vấn thông tin người dùng hiện tại từ Firestore
      DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUser!.email)
          .get();

      // Lấy dữ liệu người dùng hiện tại
      Map<String, dynamic>? currentUserData = currentUserDoc.data() as Map<String, dynamic>?;
      debugPrint("Thông tin người dùng hiện tại: $currentUserData");


      // Kiểm tra và lấy thông tin người dùng hiện tại
      String currentUsername = currentUserData?['username'] ?? 'Unknown';
      String currentEmail = currentUserData?['email'] ?? 'Unknown';
      String currentProfileImage = currentUserData?['profile_image'] ?? 'default_profile_image_url';

      // Cấu trúc yêu cầu kết bạn
      Map<String, dynamic> friendRequestData = {
        'uid': currentUserUid,
        'username': currentUsername,
        'email': currentEmail,
        'profile_image': currentProfileImage,
      };

      // Truy vấn thông tin người nhận (friendUid) từ Firestore
      DocumentSnapshot friendUserDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(friendUid)
          .get();

      // Kiểm tra xem người nhận yêu cầu kết bạn có tồn tại không
      if (!friendUserDoc.exists) {
        throw Exception('Người nhận yêu cầu kết bạn không tồn tại.');
      }

      // Lấy document của người nhận yêu cầu kết bạn từ Firestore (collection 'FriendRequests')
      DocumentReference friendRequestDoc = FirebaseFirestore.instance
          .collection('FriendRequests')
          .doc(friendUid);

      // Thêm yêu cầu kết bạn vào field "list" trong tài liệu của người nhận
      await friendRequestDoc.update({
        'list': FieldValue.arrayUnion([friendRequestData])
      }).catchError((error) async {
        // Nếu document không tồn tại, tạo document mới
        if (error is FirebaseException && error.code == 'not-found') {
          await friendRequestDoc.set({
            'list': [friendRequestData]
          });
        } else {
          throw error; // Nếu lỗi khác, ném lỗi ra
        }
      });

      debugPrint('Gửi yêu cầu kết bạn thành công đến $friendUid');
    } catch (e) {
      debugPrint('Lỗi khi gửi yêu cầu kết bạn: $e');
    }
  }
}
