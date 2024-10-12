import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart'; // Thêm Firebase Auth

class ListFriendService {
  final String baseUrl = 'https://apilistfriends.onrender.com/api'; // Thay đổi địa chỉ API của bạn

  // Hàm để lấy ID Token của người dùng hiện tại
  Future<String?> _getUserToken() async {
    User? user = FirebaseAuth.instance.currentUser; // Lấy người dùng hiện tại từ FirebaseAuth
    if (user != null) {
      return await user.getIdToken(); // Lấy ID Token
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getFriendRequests() async {
    String? token = await _getUserToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/friend-requests'),
      headers: {'Authorization': 'Bearer $token'}, // Thêm header với token
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load friend requests');
    }
  }

  Future<void> confirmFriendRequest(String requestId) async {
    String? token = await _getUserToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/accept-friend-request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Thêm header với token
      },
      body: jsonEncode({'requestId': requestId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to confirm friend request');
    }
  }

  Future<void> deleteFriendRequest(String requestId) async {
    String? token = await _getUserToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/decline-friend-request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Thêm header với token
      },
      body: jsonEncode({'requestId': requestId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete friend request');
    }
  }
}
