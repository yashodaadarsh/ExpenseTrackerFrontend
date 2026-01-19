
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_urls.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../service_locator.dart';

class CheckTokenHelper{
  static Future<Either> checkAccessToken( String? accessToken ) async {

    final prefs = await SharedPreferences.getInstance();

    if (accessToken == null) {
      return const Left("Tokens not found. Please login again.");
    }

    print("AccessToken :- $accessToken");

    try {
      print("\n\nChecking Access Token\n\n");
      final accessCheckResponse = await s1<DioHelper>().get(
        url: ApiUrls.accessTokenCheckUrl,
        token: accessToken,
      );
      print("Access token check response :- $accessCheckResponse");

      if (accessCheckResponse != null) {
        await prefs.setString('userId', accessCheckResponse);
        print("\n\n\nUser Id Saved :- $accessCheckResponse \n\n\n");
        return Right(accessCheckResponse);
      }

      return const Left("Access Token expired.");
    } on DioException catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either> generateAccessTokenWithRefreshToken( String? refreshToken ) async {

    print("\n\nRefreshing Token\n\n");
    final refreshResponse = await s1<DioHelper>().post(
      url: ApiUrls.refreshTokenUrl,
      requestBody: {
        'token': refreshToken,
      },
    );

    print("RefreshToken Response form token check Helper := $refreshResponse");

    if (refreshResponse != null && refreshResponse is Map<String, dynamic>) {
      await saveTokens(refreshResponse);
      print("Refreshtoken response :-- $refreshResponse");
      return Right(refreshResponse);
    }

    if( refreshResponse == null ) return Left("Session expired. Please login again.");

    return checkAccessToken( refreshResponse['accessToken'] );
  }

  static Future<void> saveTokens(Map<String, dynamic> data) async {
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