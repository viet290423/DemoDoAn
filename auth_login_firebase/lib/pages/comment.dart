import 'dart:math';
import 'package:auth_login_firebase/database/comment_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId; // postId của bài viết
  final String postUserEmail; // Email của người tạo bài viết
  final String postUserName;

  CommentBottomSheet({
    required this.postId,
    required this.postUserEmail,
    required this.postUserName,
  });

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  final User? user = FirebaseAuth.instance.currentUser; // Lấy thông tin người dùng hiện tại
  List<dynamic>? userFriends; // Danh sách bạn bè của người dùng hiện tại

  final List<String> _emojiList = [
    '🍎', '🍌', '🥕', '🍩', '🥚', '🍟', '🍇', '🥑', '🍦', '🥝',
    '🍪', '🍋', '🍈', '🍉', '🍊', '🍍', '🥒', '🍓', '🍠', '🍇',
    '🍉', '🍒', '🍔', '🍕', '🍞', '🥭', '🍫', '🍯', '🍑', '🍏',
    '🍑', '🍆', '🥥', '🍅', '🍡', '🍙', '🍘', '🍨', '🍮', '🍧'
  ];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Lấy danh sách bạn bè của người dùng hiện tại khi khởi tạo
    _loadUserFriends();
  }

  Future<void> _loadUserFriends() async {
    if (user != null) {
      DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user!.email)
          .get();

      setState(() {
        Map<String, dynamic>? userData = currentUserDoc.data() as Map<String, dynamic>?;
        userFriends = userData?['listFriend'] ?? [];
      });
    }
  }

  // Kiểm tra xem người bình luận có là bạn với người dùng hiện tại không
  bool _isFriendWithCommenter(String commenterEmail) {
    if (userFriends == null) return false;
    return userFriends!.any((friend) => friend['email'] == commenterEmail);
  }

  // Function to encrypt text to random emojis
  String encryptCommentToEmoji(String text) {
    return text.split('').map((char) {
      return _getRandomEmoji(); // Get a random emoji for each character
    }).join('');
  }

  // Function to get a random emoji from the list
  String _getRandomEmoji() {
    return _emojiList[_random.nextInt(_emojiList.length)];
  }

  // Định dạng thời gian
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                height: 5.0,
                width: 50.0,
                color: Colors.grey[300],
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              ),
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: _commentService.getCommentsStream(
                      widget.postId, widget.postUserEmail),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    List<DocumentSnapshot> comments = snapshot.data!;

                    if (comments.isEmpty) {
                      return Center(child: Text('No comments yet. Be the first!'));
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var commentData = comments[index].data() as Map<String, dynamic>;
                        String commenterEmail = commentData['UserEmail'];

                        // Luôn hiển thị bình luận gốc của người dùng hiện tại
                        if (commenterEmail == user?.email) {
                          return _buildCommentTile(commentData, commentData['CommentText']); // Luôn hiển thị bình luận gốc cho chính người dùng hiện tại
                        }

                        // Kiểm tra mối quan hệ bạn bè với người bình luận
                        bool isFriend = _isFriendWithCommenter(commenterEmail);

                        // Hiển thị bình luận dạng mã hóa nếu không phải bạn bè
                        String displayedComment = isFriend
                            ? commentData['CommentText']
                            : encryptCommentToEmoji(commentData['CommentText']);

                        return _buildCommentTile(commentData, displayedComment);
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1.0),
              _buildCommentInput(),
            ],
          );
        },
      ),
    );
  }

  // Hàm để xây dựng widget bình luận
  Widget _buildCommentTile(Map<String, dynamic> commentData, String displayedComment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(commentData['AvatarUrl']),
      ),
      title: Text(commentData['UserName']),
      subtitle: Text(displayedComment),
      trailing: Text(
        _formatTimestamp(commentData['CommentTime']),
        style: TextStyle(fontSize: 12),
      ),
    );
  }


  // Form nhập bình luận
  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Add a comment...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_commentController.text.trim().isNotEmpty) {
                _commentService.addComment(
                  widget.postId,
                  widget.postUserEmail,
                  _commentController.text.trim(),
                );
                _commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
