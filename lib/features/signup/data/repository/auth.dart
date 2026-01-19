import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/signup/data/models/signup_req.dart';
import 'package:expense_tracker/features/signup/data/source/auth_api_service.dart';
import 'package:expense_tracker/features/signup/domain/repository/auth.dart';

import '../../../../service_locator.dart';

class AuthRepositoryImpl extends AuthRepository{
  @override
  Future<Either> signup(SignupReqParams signupReqParams) async {
    return s1<AuthApiService>().signup(signupReqParams);
  }

}