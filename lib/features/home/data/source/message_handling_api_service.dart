import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

import '../../../../core/constants/api_urls.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../service_locator.dart';

abstract class MessageHandlingApiService {
  Future<Either> sendMessage(SmsMessage message);

  Future<List<Map<String, dynamic>>> loadTransactions( );

  Future<Either<String, Map<String, dynamic>>> getUserDetails();
}

class MessageHandlingApiServiceImpl extends MessageHandlingApiService{
  @override
  Future<Either<dynamic, dynamic>> sendMessage(SmsMessage message) async {
    try {
      print("Received the message to be processed ${message.body}");
      DioHelper dio = new DioHelper();

      final tokens = await getSavedTokens();

      print("Tokens for automatic message :- $tokens");
      print("UserId :- ${tokens['userId']}");

      var response = await dio.post(
        url: ApiUrls.readMessageUrl,
        requestBody: {
          'message': '${message.body}',
        },
        user_id: tokens['userId']
      );

      final int timestamp = message.date ?? 0;

      final DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

      response['date'] = "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";

      print(" Message read response from dsservice :- $response");


      if (response == null) {
        return const Left("Invalid Message");
      }

      final responseData = response as Map<String, dynamic>;


      return Right(responseData);

    } on DioException catch (e) {
      return Left(e.toString());
    }

  }

  @override
  Future<List<Map<String, dynamic>>> loadTransactions() async {
    try {

      final tokens = await getSavedTokens();
      final String? userId = tokens['userId'];
      final String? accessToken = tokens['accessToken'];

      // print("Function hitting the loadTransactions with userId :- $userId");

      if (userId == null || accessToken == null) {
        throw Exception("User not logged in");
      }

      final response = await s1<DioHelper>().get(
        url: ApiUrls.getExpenseUrl, // "/getExpense"
        queryParameters: {
          'user_id': userId,
        },
        token: accessToken
      );

      // print("Load Transactions response :- $response");

      if (response == null || response is! List) {
        throw Exception("Invalid expense response");
      }

      for( var expense in response ) {
        print("List of transactions :- ${expense['amount'].toString()}");
      }

      return response.map<Map<String, dynamic>>((expense) {
        final amount = double.tryParse(expense['amount'].toString()) ?? 0;


        return {
          'title': expense['merchant'] ?? 'Unknown',
          'amount': amount,
          'date': formatDateTime( expense['created_at'].toString() ),
          'icon': Icons.shopping_cart, // you can map this later
          'color': Colors.orange,
          'isExpense': amount > 0,
        };
      }).toList();

    } catch (e) {
      debugPrint("loadTransactions error: $e");
      rethrow;
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

  String formatDateTime(String isoDate) {
    if (isoDate == null) return '--';

    try {
      final DateTime dt = DateTime.parse(isoDate.toString()).toLocal();

      final String day = dt.day.toString().padLeft(2, '0');
      final String month = dt.month.toString().padLeft(2, '0');
      final String year = dt.year.toString();

      final String hour = dt.hour.toString().padLeft(2, '0');
      final String minute = dt.minute.toString().padLeft(2, '0');

      return "$day-$month-$year $hour:$minute";
    } catch (_) {
      return '--';
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getUserDetails() async {
    try {
      final tokens = await getSavedTokens();

      final response = await s1<DioHelper>().get(
        url: ApiUrls.getUserUrl,
        requestBody: {
          'user_id': tokens['userId'],
        },
      );

      if (response == null) {
        return const Left("Invalid User Response");
      }

      print("User Details Get :- $response");

      return Right(response as Map<String, dynamic>);
    } catch (e) {
      return Left(e.toString());
    }
  }





}