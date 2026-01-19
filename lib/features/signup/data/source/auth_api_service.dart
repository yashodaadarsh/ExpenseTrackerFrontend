// Http Requests are made from here

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/core/constants/api_urls.dart';
import 'package:expense_tracker/core/network/dio_helper.dart';
import 'package:expense_tracker/features/signup/data/models/signup_req.dart';

import '../../../../service_locator.dart';
import '../../../login/data/models/login_req.dart';

abstract class AuthApiService {
  Future<Either> signup(SignupReqParams signupReqParams);
}

class AuthApiServiceImpl extends AuthApiService {

  @override
  Future<Either> signup(SignupReqParams signupReqParams) async {
    try {
      var response = await s1<DioHelper>().post(
        url: ApiUrls.registerUrl,
        requestBody: signupReqParams.toJson(),
      );

      final responseData = response as Map<String, dynamic>;


      await _saveTokens(responseData);

      return Right(responseData);


    } on DioException catch (e) {
      return e.response?.data(['message']);
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (data.containsKey('accessToken')) {
        await prefs.setString('accessToken', data['accessToken']);
        print("Access Token Saved");
      }

      if (data.containsKey('token')) {
        await prefs.setString('refreshToken', data['token']);
        print("Refresh Token Saved");
      }
    } catch (e) {
      print("Failed to save tokens: $e");
    }
  }


}
