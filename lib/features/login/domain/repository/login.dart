import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/login/data/models/login_req.dart';

abstract class LoginRepository{
  Future<Either> login(LoginReqParams loginReqParams);
  Future<Either> checkTokens( );
}
