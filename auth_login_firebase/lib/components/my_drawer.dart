import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //drawer header
              const DrawerHeader(
                  child: Icon(
                Icons.favorite,
                color: Colors.red,
              )),
              //home title
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: Text("H O M E"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              //add_screen
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                  title: Text("C A M E R A"),
                  onTap: () {
                    Navigator.pop(context);

                    // navigate to camera page
                    Navigator.pushNamed(context, '/camera_page');
                  },
                ),
              ),

              //profile title
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text("P R O F I L E"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to profile page
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),

              //user title
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.people,
                    color: Colors.black,
                  ),
                  title: Text("U S E R S"),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // navigate to profile page
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),
            ],
          ),
          // logout title
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text("L O G O U T"),
              onTap: () {
                Navigator.pop(context);

                signUserOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
