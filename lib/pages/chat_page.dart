// import 'package:auth_login_firebase/components/chat_bubble.dart';
// import 'package:auth_login_firebase/services/auth_service.dart';
// import 'package:auth_login_firebase/components/my_textfield.dart';
// import 'package:auth_login_firebase/services/auth_service.dart';
// import 'package:auth_login_firebase/services/chat_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../components/my_drawer.dart';
// import '../components/chat_bubble.dart';

// class ChatPage  extends StatelessWidget {

//   final String receiverEmail;
//   final String receiverID;

//   ChatPage({
//     super.key,
//     required this.receiverEmail,
//     required this.receiverID,
//     });
  

//   // text controller

//   final TextEditingController _messageController = TextEditingController();

  
//   //chat & auth service

//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();


//   // send message 
//   void sendMessage() async {
//     //if there os something inside the textfield 
//     if (_messageController.text.isNotEmpty) {
//       // send the message
//       await _chatService.sendMessage(receiverID, _messageController.text);
//     }

//     // clear text controller
//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(receiverEmail),
//         backgroundColor:  Colors.transparent,
//         foregroundColor:  Colors.grey,
//         elevation: 0,
//         ),

//         body: Column(children: [
//           // display all messages
//           Expanded(
//             child: _buildMessageList(),
//           ),

//           //user input
//           _buildUserInput(),
//         ],
//       ),
//     ); 
//   }

//   // build message list

//   Widget _buildMessageList() {
//     String senderID = _authService.getCurrentUser()!.uid;
//     return StreamBuilder<QuerySnapshot>(
//       stream: _chatService.getMessages(receiverID, senderID),
//       builder: (context, snapshot) {
//       //errors
//         if (snapshot.hasError) {
//           return const Text("Error");
//         }

//       // loading

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text("Loaidng..");
//         }

//       // return list view 
//         return ListView(
//           children:
//               snapshot.data!.docs.map((doc) => _buildmessageItem(doc)).toList(),

            
//         );
//     }, 
//     );
//   }

//   // build message item
//   Widget _buildmessageItem(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


//     // ís ccurrent user
//     bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
//     // align message to the right if sender is the current user , otherwise left
//     var alignment = 
//         isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

//     return Container(
//       alignment: alignment,
//       child: Column(
//         crossAxisAlignment: 
//             isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               ChatBubble(
//                 message: data["message"],
//                 isCurrentUser: isCurrentUser,
//                 )
//             ],
//       ),
//     );
//   }

//   // build message input

//   Widget _buildUserInput() {
//     return Row(
//       children: [
//           // textfield should take up most of the sapce 
//           Expanded(
//             child: MyTextField(
//               controller: _messageController,
//               hintText: "Type a message",
//               obscureText: false,
//             ),
//           ),

//           // send button
//           Container(
//             decoration: const BoxDecoration(
//               color:  Colors.green,
//               shape: BoxShape.circle,
//             ),
//             margin: const EdgeInsets.only(right: 25),
//             child: IconButton(
//               onPressed: sendMessage, 
//               icon: const Icon(Icons.arrow_upward,
//               color:  Colors.white,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }




// // chat page 
// class ChatPage extends StatelessWidget {
//   final String receiverEmail;
//   final String receiverID;

//   ChatPage({
//     super.key,
//     required this.receiverEmail,
//     required this.receiverID,
//   });

//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();

//   void sendMessage(BuildContext context) async {
//     if (_messageController.text.isNotEmpty) {
//       try {
//         await _chatService.sendMessage(receiverID, _messageController.text);
//         _messageController.clear();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to send message: $e")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(receiverEmail),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _buildMessageList(),
//           ),
//           _buildUserInput(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageList() {
//     String senderID = _authService.getCurrentUser()!.uid;
//     return StreamBuilder<QuerySnapshot>(
//       stream: _chatService.getMessages(receiverID, senderID),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text("Error"));
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("No messages yet."));
//         }

//         return ListView(
//           children: snapshot.data!.docs.map((doc) => _buildmessageItem(doc)).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildmessageItem(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return ListTile(
//       title: Text(data["message"]),
//       subtitle: Text(data["senderID"]), // Hoặc thông tin khác
//     );
//   }

//   Widget _buildUserInput(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: MyTextField(
//             controller: _messageController,
//             hintText: "Type a message",
//             obscureText: false,
//           ),
//         ),
//         IconButton(
//           onPressed: () => sendMessage(context),
//           icon: const Icon(Icons.arrow_upward),
//         ),
//       ],
//     );
//   }
// }


// chat_page_2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({Key? key, required this.receiverEmail, required this.receiverID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  // Hàm gửi tin nhắn
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Lưu tin nhắn vào Firestore
      await _firestore.collection('chats').add({
        'senderEmail': currentUser?.email,
        'receiverEmail': widget.receiverEmail,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear(); // Xóa trường nhập sau khi gửi tin nhắn
    }
  }

  // Stream để theo dõi và hiển thị tin nhắn
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trò chuyện với ${widget.receiverEmail}"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Hiển thị danh sách tin nhắn
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  var messageData = message.data() as Map<String, dynamic>;
                  var messageText = messageData['message'];
                  var senderEmail = messageData['senderEmail'];

                  var messageWidget = MessageBubble(
                    sender: senderEmail,
                    text: messageText,
                    isMe: currentUser?.email == senderEmail,
                  );
                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  reverse: true, // Để tin nhắn mới nhất xuất hiện ở dưới cùng
                  children: messageWidgets,
                );
              },
            ),
          ),
          // Ô nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget hiển thị bong bóng tin nhắn
class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageBubble({Key? key, required this.sender, required this.text, required this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
