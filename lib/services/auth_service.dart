import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        throw Exception('User canceled Google sign-in');
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await _addUserToFirestore(userCredential.user);

      return userCredential;
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  // Thêm người dùng vào Firestore nếu chưa tồn tại
  Future<void> _addUserToFirestore(User? user) async {
    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('User').doc(user.email);
      DocumentSnapshot userDoc = await userRef.get();

      if (!userDoc.exists) {
        try {
          await userRef.set({
            'username': user.displayName ?? 'Unknown',
            'email': user.email,
            'profile_image': user.photoURL ?? '',
            'created_at': Timestamp.now(),
          });
        } catch (e) {
          throw Exception('Error adding user to Firestore: $e');
        }
      }
    }
  }

  // Lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
