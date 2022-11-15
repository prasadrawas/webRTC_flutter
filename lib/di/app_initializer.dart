import 'package:chat_application/data/network/FirestoreApiImpl.dart';
import 'package:chat_application/data/network/RealtimeDbApiImpl.dart';
import 'package:chat_application/repository/app_repository.dart';
import 'package:chat_application/routing/navigator_service.dart';
import 'package:chat_application/viewmodel/auth/auth_view_model.dart';
import 'package:chat_application/viewmodel/chats/chats_view_model.dart';
import 'package:get_it/get_it.dart';

class AppInitializer {
  AppInitializer._();

  static GetIt getIt = GetIt.instance;

  static initGetIt() {
    getIt = GetIt.instance;
    create();
  }

  static void create() {
    _initRepos();
    _initServices();
    _initViewModels();
  }

  static void _initRepos() {
    getIt.registerLazySingleton<AppRepository>(() => AppRepository());
  }

  static void _initServices() {
    getIt.registerLazySingleton<NavigationService>(() => NavigationService());
    getIt.registerLazySingleton<FirestoreApiImpl>(() => FirestoreApiImpl());
    getIt.registerLazySingleton<RealtimeDbApiImpl>(() => RealtimeDbApiImpl());
  }

  static void _initViewModels() {
    getIt.registerFactory(() => AuthViewModel());
    getIt.registerFactory(() => ChatsViewModel());
  }

/*


  static void _logger() {
    getIt.registerLazySingleton<Logger>(() => Logger(printer: PrettyPrinter()));
    getIt.registerLazySingleton<ConsoleLogger>(() => ConsoleLogger());
  }

  static void _initNotifiers() {}

  static void _initBlocs() {
    getIt.registerFactory(() => StoreProductBloc());
    getIt.registerFactory(() => StoreProductPromotionalBloc());
    getIt.registerFactory(() => ProductBloc());
    getIt.registerFactory(() => AisleBloc());
  }
*/

  static void close() {
    getIt.reset();
  }
}
