import 'package:dio/dio.dart';
import 'custom_dio.dart';

class DioHelper {
  final Dio dio = getDio();

  // =====================
  // COMMON OPTIONS BUILDER
  // =====================
  Options _buildOptions({String? token, String? user_id}) {
    final headers = <String, dynamic>{};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (user_id != null) {
      headers['x-user-id'] = user_id;
    }

    return Options(
      contentType: Headers.jsonContentType,
      receiveDataWhenStatusError: true,
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: headers.isNotEmpty ? headers : null,
    );
  }


  // =====================
  // GET
  // =====================
  Future<dynamic> get({
    required String url,
    Object? requestBody,
    String? token,
    Map<String, dynamic>? queryParameters
  }) async {
    try {
      final response = await dio.get(
        url,
        data: requestBody,
        queryParameters: queryParameters,
        options: _buildOptions(token: token),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  // =====================
  // POST
  // =====================
  Future<dynamic> post({
    required String url,
    Object? requestBody,
    String? token,
    String? user_id,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: requestBody,
        options: _buildOptions(token: token,user_id: user_id),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  // =====================
  // PUT
  // =====================
  Future<dynamic> put({
    required String url,
    Object? requestBody,
    String? token,
  }) async {
    try {
      final response = await dio.put(
        url,
        data: requestBody,
        options: _buildOptions(token: token),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  // =====================
  // PATCH
  // =====================
  Future<dynamic> patch({
    required String url,
    Object? requestBody,
    String? token,
  }) async {
    try {
      final response = await dio.patch(
        url,
        data: requestBody,
        options: _buildOptions(token: token),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  // =====================
  // DELETE
  // =====================
  Future<dynamic> delete({
    required String url,
    Object? requestBody,
    String? token,
  }) async {
    try {
      final response = await dio.delete(
        url,
        data: requestBody,
        options: _buildOptions(token: token),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }
}
