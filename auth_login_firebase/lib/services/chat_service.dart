import 'package:auth_login_firebase/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Phương thức lấy danh sách bạn bè
  Stream<List<Map<String, dynamic>>> getFriendsStream() async* {
    final String currentUserID = _auth.currentUser!.uid;

    // Lấy danh sách bạn bè của người dùng hiện tại từ Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
        .collection('User')
        .doc(currentUserID)
        .get();

    if (userDoc.exists) {
      List<dynamic> friendsIDs = userDoc.data()?['listFriend'] ?? [];

      // Stream danh sách người dùng là bạn bè
      yield* _firestore
          .collection('User')
          .where('uid', whereIn: friendsIDs)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          // Chuyển đổi dữ liệu thành Map
          final user = doc.data() as Map<String, dynamic>;
          return user;
        }).toList();
      });
    } else {
      yield [];
    }
  }

  // Phương thức lấy danh sách người dùng
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("User").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Lấy dữ liệu từ document và chuyển đổi nó thành Map
        final user = doc.data() as Map<String, dynamic>;

        // Trả về thông tin người dùng
        return user;
      }).toList();
    });
  }

  // Phương thức gửi tin nhắn
  Future<void> sendMessage(String receiverID, String message) async {
    // Lấy thông tin người dùng hiện tại
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Tạo tin nhắn mới
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Tạo ID cho phòng chat giữa hai người
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // Sắp xếp để đảm bảo tính nhất quán
    String chatRoomID = ids.join('_');

    // Thêm tin nhắn vào cơ sở dữ liệu
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Phương thức nhận tin nhắn
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // Tạo ID phòng chat giữa hai người dùng
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}


