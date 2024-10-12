import 'dart:io';
import 'package:auth_login_firebase/database/firestore.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  final File imageFile;
  final double cameraAspectRatio;

  const PostPage(
      {super.key, required this.imageFile, required this.cameraAspectRatio});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController messageController = TextEditingController();
  bool isLoading = false;

  // Hàm post để lưu ảnh và thông điệp vào Firebase
  Future<void> postToFirebase(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    // Gọi hàm lưu ảnh và thông điệp vào Firebase
    FirestoreDatabase database = FirestoreDatabase();
    await database.addPost(messageController.text, widget.imageFile);

    // Sau khi post xong thì quay lại HomePage
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Your Image'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: AspectRatio(
                          aspectRatio: widget.cameraAspectRatio,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Image.file(widget.imageFile),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter your message",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      postToFirebase(context);
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
            ),
    );
  }
}
