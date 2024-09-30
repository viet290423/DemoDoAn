import 'package:auth_login_firebase/components/my_drawer.dart';
import 'package:auth_login_firebase/components/my_list_title.dart';
import 'package:auth_login_firebase/components/search_friend.dart';
import 'package:auth_login_firebase/database/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(
      String userEmail) {
    return FirebaseFirestore.instance
        .collection('User')
        .doc(userEmail)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "W A L L",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    FriendSearchDelegate(), // Sử dụng lớp FriendSearchDelegate
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: database.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text("An error occurred. Please try again later."),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text("No posts.. Post something!"),
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;

              String imageUrl = post['ImageUrl'] ?? '';
              String message = post['PostMessage'] ?? 'No message';
              String userEmail = post['UserEmail'] ?? 'Unknown';
              String id = post['PostId'] ?? '';
              Timestamp timestamp = post['TimeStamp'] ?? Timestamp.now();

              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: getUserStream(userEmail),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return ListTile(
                      title: Text(message),
                      subtitle: Text('Error loading username'),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.exists) {
                      Map<String, dynamic> userData = snapshot.data!.data()!;
                      String userName = userData['username'] ?? 'Unknown';

                      return MyListTitle(
                        title: message,
                        userEmail: userEmail,
                        userName: userName,
                        timestamp: timestamp,
                        imageUrl: imageUrl,
                        postId: id,
                      );
                    } else {
                      return ListTile(
                        title: Text(message),
                        subtitle: Text('Username not found'),
                      );
                    }
                  } else {
                    return ListTile(
                      title: Text(message),
                      subtitle: Text('Username not available'),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
