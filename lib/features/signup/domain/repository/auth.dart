import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/signup/data/models/signup_req.dart';

abstract class AuthRepository{
  Future<Either> signup(SignupReqParams signupReqParams);
}