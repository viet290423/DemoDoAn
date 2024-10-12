// import 'package:auth_login_firebase/models/message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// class ChatService {

//   // get intance of firestore

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // get user stream
//   /* 

//   List<Map>String,dynamic> = 
//   [
//   {
//     'email' : ngoc@gmail.com,
//     'id': ..
//   },
//   {
//     'email': ngoc@gmail.com,
//     'id': .. 

//   }
//   ]
//   */

//   Stream<List<Map<String, dynamic>>> getUsersStream() {
//     return _firestore.collection("Users").snapshots().map((snapshot) {
//       return snapshot.docs.map((doc){
//         // go through each invidiual user

//         final user = doc.data();


//         // return  user
//         return user;

//       }).toList();

//     });
//   }

//   //send messgae
//   Future<void> sendMessage(String receiverID, message)  async {

//     //get current user info 
//     final String currentUserID = _auth.currentUser!.uid;
//     final String currentUserEmail = _auth.currentUser!.email!;
//     final Timestamp timestamp = Timestamp.now();


//     // create a new message
     
//      Message newMessage = Message(
//       senderID: currentUserEmail,
//       senderEmail: currentUserID,
//       receiverID: receiverID,
//       message: message,
//       timestamp: timestamp,
//      );
//     // construct chat room ID for the twos users () 
//     List<String> ids = [currentUserID, receiverID];
//     ids.sort();  // sort the ids ( this ensure the chatroomID is the same for any 2 people)
//     String chatRoomID = ids.join('_');


//         // add new message to database

//     await _firestore
//         .collection("chat_rooms")
//         .doc(chatRoomID)
//         .collection("messages")
//         .add(newMessage.toMap());
//   }


    
//   // get message
//   Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
//     // construct a chat room ID for two users

//     List<String> ids = [userID, otherUserID];
//     ids.sort();
//     String chatRoomID = ids.join('_');

//     return _firestore 
//     .collection("chat_rooms")
//     .doc(chatRoomID)
//     .collection("message")
//     .orderBy("timestam", descending: false)
//     .snapshots();
//   }
// }



import 'package:auth_login_firebase/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Khởi tạo instance của Firestore và FirebaseAuth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Phương thức lấy danh sách người dùng
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
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

