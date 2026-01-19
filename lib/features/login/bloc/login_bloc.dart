import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../service_locator.dart';
import '../domain/usecase/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final LoginUseCase loginUseCase = s1<LoginUseCase>();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmittedEvent>((event, emit) async {
      emit(LoginLoading());

      try {
        var result = await loginUseCase.call(param: event.loginReqParams);

        result.fold(
              (error) => emit(LoginFailure(message: error.toString())),
              (data) => emit(LoginSuccess()),
        );
      } catch (e) {
        emit(LoginFailure(message: e.toString()));
      }
    });
  }
}