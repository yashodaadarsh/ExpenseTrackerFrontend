import 'dart:convert';

import 'package:expense_tracker/core/constants/api_urls.dart';
import 'package:expense_tracker/core/network/dio_helper.dart';
import 'package:http/http.dart' as http;

import '../../../../service_locator.dart';
import '../models/expenseDto.dart';

class ExpenseService {
  // Replace with your actual machine IP/URL
  static const String _baseUrl = "http://10.118.102.247:9820";

  Future<bool> addExpense(ExpenseDto expense, String userId) async {

    try {
      final response = await s1<DioHelper>().post(
        url: ApiUrls.addExpenseUrl,
        requestBody: expense.toJson(),
        user_id: userId
      );

      print("Add Expense Response :- $response");

      if (response == true ) {
        return true;
      } else {
        print("Failed to add expense: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error calling API: $e");
      return false; // Or throw exception depending on how you handle errors
    }
  }
}