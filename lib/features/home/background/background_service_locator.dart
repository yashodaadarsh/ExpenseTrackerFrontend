import 'package:get_it/get_it.dart';
import '../data/source/message_handling_api_service.dart';

final GetIt bg = GetIt.instance;

void setupBackgroundServiceLocator() {
  if (!bg.isRegistered<MessageHandlingApiService>()) {
    bg.registerLazySingleton<MessageHandlingApiService>(
          () => MessageHandlingApiServiceImpl(),
    );
  }
}
