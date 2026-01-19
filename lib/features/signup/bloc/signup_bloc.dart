import 'dart:async'; // 1. Required for FutureOr
import 'package:bloc/bloc.dart';
import 'package:expense_tracker/features/signup/domain/usecases/signup.dart';
import '../../../../service_locator.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {

  final SignupUseCase signupUseCase = s1<SignupUseCase>();

  SignupBloc() : super(SignupInitial()) {

    on<SignupInitialEvent>(_signupInitialEvent);
    // Register the handler
    on<SignupSubmittedEvent>(_signupSubmittedEvent);
    
    on<SignupFailureEvent>(_signupFailureEvent);
  }

  FutureOr<void> _signupInitialEvent(
      SignupInitialEvent event,
      Emitter<SignupState> emit,
      ){

    emit(SignupInitial());

  }

  FutureOr<void> _signupFailureEvent(
      SignupFailureEvent event,
      Emitter<SignupState> emit,
      ){

    emit(SignupFailure(message: event.message));

  }
  
  // 2. Define the method with correct types
  FutureOr<void> _signupSubmittedEvent(
      SignupSubmittedEvent event,
      Emitter<SignupState> emit,
      ) async {

    emit(SignupLoading());

    try {
      var result = await signupUseCase.call(param: event.signupReqParams);

      result.fold(
            (error) => emit(SignupFailure(message: error.toString())),
            (data) => emit(SignupSuccess()),
      );
    } catch (e) {
      emit(SignupFailure(message: e.toString()));
    }
  }
}




// import 'package:bloc/bloc.dart';
// import 'package:expense_tracker/features/signup/domain/usecases/signup.dart';
// import '../../../../service_locator.dart';
// import 'signup_event.dart';
// import 'signup_state.dart';
//
// class SignupBloc extends Bloc<SignupEvent, SignupState> {
//
//
//   final SignupUseCase signupUseCase = s1<SignupUseCase>();
//
//   SignupBloc() : super(SignupInitial()) {
//
//     on<SignupSubmittedEvent>((event, emit) async {
//
//
//       emit(SignupLoading());
//
//       try {
//
//         var result = await signupUseCase.call(param: event.signupReqParams);
//
//
//         result.fold(
//               (error) => emit(SignupFailure(message: error.toString())),
//               (data) => emit(SignupSuccess()),
//         );
//       } catch (e) {
//         emit(SignupFailure(message: e.toString()));
//       }
//     });
//   }
// }