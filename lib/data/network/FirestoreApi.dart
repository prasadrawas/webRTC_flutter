import 'package:chat_application/model/ChatUser.dart';

abstract class FirestoreApi {
  Future<dynamic> signIn({required String email, required String password});
  Future<dynamic> signUp({required ChatUser user, required String password});
  dynamic isSignedIn();
  Future<dynamic> storeUserData({required ChatUser user});
  Future<dynamic> getUserData();
  Future<dynamic> getUserDataByRef({required String ref});
}
