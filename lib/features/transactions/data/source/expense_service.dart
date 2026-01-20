
import 'package:expense_tracker/core/constants/api_urls.dart';
import 'package:expense_tracker/core/network/dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../service_locator.dart';
import '../models/expenseDto.dart';

class ExpenseService {

  Future<bool> addExpense(ExpenseDto expense) async {

    final tokens = await getSavedTokens();
    final String? accessToken = tokens['accessToken'];


    try {
      final response = await s1<DioHelper>().post(
        url: ApiUrls.addExpenseUrl,
        token: accessToken,
        requestBody: expense.toJson(),
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