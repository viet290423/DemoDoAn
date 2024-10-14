import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth_page', (route) => false); // Đưa người dùng về trang đăng nhập sau khi đăng xuất
    });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng hộp thoại
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng hộp thoại trước khi đăng xuất
              signUserOut(context); // Gọi hàm đăng xuất
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header
              const DrawerHeader(
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
              // home title
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

              // camera page
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
                    Navigator.pushNamed(context, '/camera_page');
                  },
                ),
              ),

              // profile page
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text("P R O F I L E"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),

              // users page
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.people,
                    color: Colors.black,
                  ),
                  title: Text("U S E R S"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),

              // notification page
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  title: Text("N O T I F I C A T I O N S"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notification_page');
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.chat_bubble,
                    color: Colors.black,
                  ),
                  title: Text("C H A T"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home_chat_page');
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
                showLogoutDialog(context); // Hiển thị hộp thoại xác nhận đăng xuất
              },
            ),
          ),
        ],
      ),
    );
  }
}
