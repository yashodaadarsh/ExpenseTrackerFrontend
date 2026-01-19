

import '../../../../core/models/user_dto.dart';

abstract class HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState {
  final List<Map<String, dynamic>> transactions;
  final double totalExpense;
  final UserDto userDto;

  HomePageLoadedState({
    required this.transactions,
    required this.totalExpense,
    required this.userDto,
  });
}

class HomePageErrorState extends HomePageState {
  final String message;
  HomePageErrorState(this.message);
}
