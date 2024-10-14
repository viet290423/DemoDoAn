import 'package:auth_login_firebase/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Khởi tạo instance của Firestore và FirebaseAuth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    // Tạo một tin nhắn mới
    Message newMessage = Message(
      senderID: currentUserID, // Sử dụng ID của người gửi
      senderEmail: currentUserEmail, // Email của người gửi
      receiverID: receiverID, // ID của người nhận
      message: message, // Nội dung tin nhắn
      timestamp: timestamp, // Thời gian gửi
    );

    // Tạo ID cho phòng chat giữa hai người dùng
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // Sắp xếp ID để đảm bảo ID phòng chat nhất quán
    String chatRoomID = ids.join('_');

    // Thêm tin nhắn mới vào cơ sở dữ liệu
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Phương thức nhận tin nhắn
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // Tạo ID cho phòng chat giữa hai người dùng
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages") // Chỉnh sửa thành "messages"
        .orderBy("timestamp", descending: false) // Đảm bảo trường đúng tên là "timestamp"
        .snapshots();
  }
}

