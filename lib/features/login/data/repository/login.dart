import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/login/data/models/login_req.dart';
import 'package:expense_tracker/features/login/data/source/login_api_service.dart';
import 'package:expense_tracker/features/login/domain/repository/login.dart';
import '../../../../service_locator.dart';

class LoginRepositoryImpl extends LoginRepository{
  @override
  Future<Either> login(LoginReqParams loginReqParams) {
    return s1<LoginApiService>().login(loginReqParams);
  }

  @override
  Future<Either> checkTokens( ) {
    return s1<LoginApiService>().checkTokens();
  }

}