import 'package:get_it/get_it.dart';
import 'package:grocery_delivery/logic/navigation/router.dart';

final getIt = GetIt.instance;

void initNavigatorService() {
  final navService = AppRouter();

  getIt.registerSingleton<AppRouter>(navService);
}