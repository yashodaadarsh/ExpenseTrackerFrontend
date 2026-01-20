import 'dart:convert';
import 'package:expense_tracker/core/constants/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/models/user_dto.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../service_locator.dart';

class UserService {

  Future<bool> updateUser(UserDto user) async {
    final tokens = await getSavedTokens();
    final String? accessToken = tokens['accessToken'];

    try {
      final response = await s1<DioHelper>().post(
        url: ApiUrls.updateUserUrl,
        requestBody: jsonEncode(user.toJson()),
        token: accessToken
      );

      print("Update User response :- $response");

      // Success case
      if (response is Map && response.containsKey('user_id')) {
        return true;
      }

      // Error case
      if (response is Map && response.containsKey('message')) {
        print("Update failed: ${response['message']}");
        return false;
      }

      // Unexpected shape
      print("Unexpected response format: $response");
      return false;
    } catch (e) {
      print("Error calling API: $e");
      return false;
    }
  }


  Future<Map<String, String?>> getSavedTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    return {
      'accessToken': prefs.getString('accessToken'),
      'refreshToken': prefs.getString('refreshToken'),
      'userId': prefs.getString('userId')
    };
  }

}