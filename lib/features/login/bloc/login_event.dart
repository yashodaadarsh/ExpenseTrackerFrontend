import 'package:expense_tracker/features/login/data/models/login_req.dart';

abstract class LoginEvent {}

class LoginSubmittedEvent extends LoginEvent {
  final LoginReqParams loginReqParams;
  LoginSubmittedEvent({required this.loginReqParams});
}