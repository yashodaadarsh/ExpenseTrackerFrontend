
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:expense_tracker/features/login/data/models/login_req.dart';
import 'package:expense_tracker/features/login/data/source/tokencheckfunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_urls.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../service_locator.dart';

abstract class LoginApiService {
  Future<Either> login( LoginReqParams loginReqParams );
  Future<Either> checkTokens();
}

class LoginApiServiceImpl extends LoginApiService{

  @override
  Future<Either> login(LoginReqParams loginReqParams) async {
    try {
      var response = await s1<DioHelper>().post(
        url: ApiUrls.loginUrl,
        requestBody: loginReqParams.toMap(),
      );

      print(" Credentials :- $response");

      // 1. Check for NULL before casting
      if (response == null) {
        return const Left("Invalid Credentials");
      }

      // 2. Now it is safe to cast
      final responseData = response as Map<String, dynamic>;

      await _saveTokens(responseData);

      return Right(responseData);

    } on DioException catch (e) {
      // Handle Dio specific errors
      String errorMessage = 'Login failed';
      if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? 'Connection Error';
      }
      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
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

  @override
  Future<Either<String, dynamic>> checkTokens() async {
    final tokens = await getSavedTokens();

    final accessToken = tokens['accessToken'];
    final refreshToken = tokens['refreshToken'];

    if (accessToken == null || refreshToken == null) {
      return const Left("Tokens not found. Please login again.");
    }

    final accessResult = await CheckTokenHelper.checkAccessToken(accessToken);

    return await accessResult.fold(
          (failure) async {
        final refreshResult =
        await CheckTokenHelper.generateAccessTokenWithRefreshToken(
            refreshToken);

        return refreshResult.fold(
              (error) => const Left("Session expired. Please login again."),
              (data) => Right(data),
        );
      },
          (success) => Right(success),
    );
  }


  Future<Map<String, String?>> getSavedTokens() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'accessToken': prefs.getString('accessToken'),
      'refreshToken': prefs.getString('refreshToken'),
    };

  }


}