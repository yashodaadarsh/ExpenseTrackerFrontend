import 'package:bloc/bloc.dart';

import '../../../../core/models/user_dto.dart';
import '../../../../service_locator.dart';
import '../../data/source/message_handling_api_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final MessageHandlingApiService service = s1<MessageHandlingApiService>();

  HomePageBloc() : super(HomePageLoadingState()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<IncomingSmsEvent>(_onIncomingSms);
  }

  Future<void> _onLoadTransactions(
      LoadTransactionsEvent event,
      Emitter<HomePageState> emit,
      ) async {
    emit(HomePageLoadingState());

    try {
      // Execute both requests
      final transactions = await service.loadTransactions();
      final userResult = await service.getUserDetails(); // Returns Either<String, Map>

      userResult.fold(
            (error) {
          emit(HomePageErrorState(error));
        },
            (userJson) {
          final userDto = UserDto.fromJson(userJson);

          final totalExpense = transactions.fold<int>(
            0,
                (sum, item) {
              final amount = int.tryParse(item['amount'].toString()) ?? 0;
              return sum + amount;
            },
          );

          emit(
            HomePageLoadedState(
              transactions: transactions,
              userDto: userDto,
              totalExpense: totalExpense,
            ),
          );
        },
      );
    } catch (e) {
      emit(HomePageErrorState("Failed to load data: $e"));
    }
  }

  Future<void> _onIncomingSms(
      IncomingSmsEvent event,
      Emitter<HomePageState> emit,
      ) async {
    await service.sendMessage(event.message);

    // Re-load transactions after new SMS
    add(LoadTransactionsEvent());
  }
}
