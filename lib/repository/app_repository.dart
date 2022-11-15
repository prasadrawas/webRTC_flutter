import 'package:chat_application/data/app_exceptions.dart';
import 'package:chat_application/data/network/FirestoreApiImpl.dart';
import 'package:chat_application/data/network/RealtimeDbApiImpl.dart';
import 'package:chat_application/di/app_initializer.dart';
import 'package:chat_application/model/ChatUser.dart';
import 'package:chat_application/model/Message.dart';
import 'package:chat_application/utils/utilities.dart';

class AppRepository {
  final fireStoreApi = AppInitializer.getIt<FirestoreApiImpl>();
  final realtimeApi = AppInitializer.getIt<RealtimeDbApiImpl>();

  Future isSignedIn() async {
    if (await isConnected()) {
      try {
        return fireStoreApi.isSignedIn();
      } on AppException catch (e) {
        throw NetworkFailedException(e.toString());
      }
    }
  }

  Future signIn({required String email, required String password}) async {
    if (await isConnected()) {
      try {
        return fireStoreApi.signIn(email: email, password: password);
      } on AppException catch (e) {
        throw SignInFailedException(e.toString());
      }
    }
  }

  Future signUp({required ChatUser user, required String password}) async {
    if (await isConnected()) {
      try {
        return fireStoreApi.signUp(user: user, password: password);
      } on AppException catch (e) {
        throw SignUpFailedException(e.toString());
      }
    }
  }

  Future getUserData() async {
    if (await isConnected()) {
      try {
        return fireStoreApi.getUserData();
      } on AppException catch (e) {
        throw SignUpFailedException(e.toString());
      }
    }
  }

  Future getUserDataByRef({required String ref}) async {
    if (await isConnected()) {
      try {
        return fireStoreApi.getUserDataByRef(ref: ref);
      } on AppException catch (e) {
        throw SignUpFailedException(e.toString());
      }
    }
  }

  Future sendMessage(
      {required Message message, required String receiverId}) async {
    if (await isConnected()) {
      try {
        return realtimeApi.sendMessage(
            message: message, receiverId: receiverId);
      } on AppException catch (e) {
        throw SignUpFailedException(e.toString());
      }
    }
  }
}
