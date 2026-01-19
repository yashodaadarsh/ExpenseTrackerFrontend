import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/signup/domain/repository/auth.dart';
import 'package:expense_tracker/service_locator.dart';

import '../../../../core/usecase/usecase.dart';
import '../../data/models/signup_req.dart';

class SignupUseCase implements UseCase<dynamic,SignupReqParams>{
  @override
  Future<Either> call({SignupReqParams? param}) async {
    return s1<AuthRepository>().signup(param!);
  }

}