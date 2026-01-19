import '../data/models/signup_req.dart';

abstract class SignupEvent {}

class SignupInitialEvent extends SignupEvent {}

class SignupFailureEvent extends SignupEvent {
  final String message;

  SignupFailureEvent({required this.message});
}


class SignupSubmittedEvent extends SignupEvent{

  final SignupReqParams signupReqParams;

  SignupSubmittedEvent({required this.signupReqParams});

}

