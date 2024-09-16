import 'package:auth_login_firebase/auth/auth_page.dart';
import 'package:auth_login_firebase/auth/login_or_register_page.dart';
import 'package:auth_login_firebase/auth/login_page.dart';
import 'package:auth_login_firebase/pages/camera_page.dart';
import 'package:auth_login_firebase/pages/home_page.dart';
import 'package:auth_login_firebase/pages/profile_page.dart';
import 'package:auth_login_firebase/pages/users_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras,));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/login_register_page': (context) => const LoginOrRegisterPage(),
        '/home_page' : (context) => HomePage(),
        '/camera_page' : (context) => CameraPage(cameras: cameras,),
        '/profile_page' : (context) => ProfilePage(),
        '/users_page' : (context) => const UsersPage(),
      },
    );
  }
}
