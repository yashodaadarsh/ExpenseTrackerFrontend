import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/models/user_dto.dart';

class UserService {
  // Replace with your local IP
  static const String _baseUrl = "http://10.118.102.247:9810";

  Future<bool> updateUser(UserDto user) async {
    final url = Uri.parse('$_baseUrl/user/v1/createUpdate');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'X-User-Id': user.userId, // Uncomment if you need auth headers
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to update: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error calling API: $e");
      return false;
    }
  }
}