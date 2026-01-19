import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/login/data/models/login_req.dart';
import 'package:expense_tracker/features/login/domain/repository/login.dart';
import '../../../../service_locator.dart';

class CheckTokenUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? param}) async {

    return s1<LoginRepository>().checkTokens();

  }

}