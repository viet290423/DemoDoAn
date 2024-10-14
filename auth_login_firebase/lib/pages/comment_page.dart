import 'dart:math'; // For random number generation
import 'package:auth_login_firebase/components/my_textfield.dart';
import 'package:flutter/material.dart';

class CommentBottomSheet extends StatefulWidget {
  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = []; // Store both original and encrypted comments

  // Emoji lists for randomness
  final List<String> _emojiList = [
    '🍎', '🍌', '🥕', '🍩', '🥚', '🍟', '🍇', '🥑', '🍦', '🥝',
    '🍪', '🍋', '🍈', '🍉', '🍊', '🍍', '🥒', '🍓', '🍠', '🍇',
    '🍉', '🍒', '🍔', '🍕', '🍞', '🥭', '🍫', '🍯', '🍑', '🍏',
    '🍑', '🍆', '🥥', '🍅', '🍡', '🍙', '🍘', '🍨', '🍮', '🍧'
  ];

  final Random _random = Random();

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
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 5.0,
                  width: 50.0,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person),
                          ),
                          title: Text('User $index'),
                          subtitle: Text(_comments[index]['display']!), // Display either encrypted or decrypted comment
                          trailing: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              // Toggle between encrypted and original comment
                              setState(() {
                                if (_comments[index]['display'] == _comments[index]['encrypted']) {
                                  // Show original text
                                  _comments[index]['display'] = _comments[index]['original']!;
                                } else {
                                  // Show encrypted text
                                  _comments[index]['display'] = _comments[index]['encrypted']!;
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1.0),
                _buildCommentInput(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 50.0,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Padding(
              padding:const EdgeInsets.all(2.0),
              child: MyTextField(
                controller: _commentController,
                hintText: "Add a comment...",
                obscureText: false,
              ),
            )
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                setState(() {
                  // Encrypt the comment to random emojis
                  String encryptedComment = _encryptToRandomEmoji(_commentController.text);
                  // Store both original and encrypted comment
                  _comments.add({
                    'original': _commentController.text,
                    'encrypted': encryptedComment,
                    'display': encryptedComment, // Initially display encrypted comment
                  });
                  _commentController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // Function to encrypt text to random emojis
  String _encryptToRandomEmoji(String text) {
    return text.split('').map((char) {
      return _getRandomEmoji(); // Get a random emoji for each character
    }).join('');
  }

  // Function to get a random emoji from the list
  String _getRandomEmoji() {
    return _emojiList[_random.nextInt(_emojiList.length)];
  }
}
