import 'package:auth_login_firebase/components/my_back_button.dart';
import 'package:auth_login_firebase/components/my_list_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   foregroundColor: Colors.white,
      //   title: const Text(
      //     "Users",
      //     style: TextStyle(
      //       color: Colors.orange,
      //       fontSize: 24,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: Colors.black,
      // ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("User").snapshots(),
        builder: (context, snapshot) {
          //any error
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          // show loading circle
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            // ignore: unnecessary_null_comparison
          } else if (snapshot.hasData == null) {
            return const Text("No data");
          }

          // get all users
          final users = snapshot.data!.docs;
          return Column(
            children: [
              const Padding(
                padding: const EdgeInsets.only(top: 50, left: 25),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    // get individual user
                    final user = users[index];

                    String username = user['username'];
                    // String email = user['email'];

                    return Padding(
                      padding: const EdgeInsets.only(top: 10, right: 30, left: 30, bottom: 10),
                      child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: user.data().containsKey('profile_image') && user['profile_image'] != null
                                  ? NetworkImage(user['profile_image'])
                                  : null,
                              radius: 25,
                              child: !user.data().containsKey('profile_image') || user['profile_image'] == null
                                  ? const Icon(Icons.person, size: 32)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 25,
                              child: Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
