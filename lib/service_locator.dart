import 'package:expense_tracker/core/network/dio_helper.dart';
import 'package:expense_tracker/features/home/data/source/message_handling_api_service.dart';
import 'package:expense_tracker/features/login/data/source/login_api_service.dart';
import 'package:expense_tracker/features/login/domain/repository/login.dart';
import 'package:expense_tracker/features/signup/bloc/signup_bloc.dart';
import 'package:expense_tracker/features/signup/data/source/auth_api_service.dart';
import 'package:expense_tracker/features/signup/domain/usecases/signup.dart';
import 'package:expense_tracker/features/transactions/data/source/expense_service.dart';
import 'package:get_it/get_it.dart';

import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/login/bloc/login_bloc.dart';
import 'features/login/data/repository/login.dart';
import 'features/login/domain/usecase/login.dart';
import 'features/login/domain/usecase/tokencheck.dart';
import 'features/signup/data/repository/auth.dart';
import 'features/signup/domain/repository/auth.dart';

final s1 = GetIt.instance;

void setUpServiceLocator(){
  s1.registerSingleton<DioHelper>(DioHelper());

  // Service
  s1.registerSingleton<AuthApiService>(
    AuthApiServiceImpl()
  );
  s1.registerSingleton<LoginApiService>(
    LoginApiServiceImpl()
  );
  s1.registerSingleton<MessageHandlingApiService>(
      MessageHandlingApiServiceImpl()
  );
  s1.registerSingleton<ExpenseService>(
      ExpenseService()
  );

  // Repositories
  s1.registerSingleton<AuthRepository>(
      AuthRepositoryImpl()
  );
  s1.registerSingleton<LoginRepository>(
    LoginRepositoryImpl()
  );

  //UseCases
  s1.registerSingleton<SignupUseCase>(
      SignupUseCase()
  );
  s1.registerSingleton<LoginUseCase>(
      LoginUseCase()
  );
  s1.registerSingleton<CheckTokenUseCase>(
    CheckTokenUseCase()
  );

  //bloc
  s1.registerSingleton<SignupBloc>(
      SignupBloc()
  );
  s1.registerSingleton<LoginBloc>(
      LoginBloc()
  );
  s1.registerFactory<HomePageBloc>(
        () => HomePageBloc(),
  );

}