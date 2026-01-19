import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/login/data/models/login_req.dart';
import 'package:expense_tracker/features/login/domain/repository/login.dart';
import '../../../../service_locator.dart';

class LoginUseCase implements UseCase<Either, LoginReqParams> {
  @override
  Future<Either> call({LoginReqParams? param}) async {

    return s1<LoginRepository>().login(param!);

  }


}