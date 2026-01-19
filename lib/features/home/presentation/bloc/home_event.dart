import 'package:telephony/telephony.dart';

abstract class HomePageEvent {}

class LoadTransactionsEvent extends HomePageEvent {}

class IncomingSmsEvent extends HomePageEvent {
  final SmsMessage message;
  IncomingSmsEvent(this.message);
}
