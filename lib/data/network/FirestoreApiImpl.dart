import 'package:chat_application/constants/firestore_ref.dart';
import 'package:chat_application/data/app_exceptions.dart';
import 'package:chat_application/data/network/FirestoreApi.dart';
import 'package:chat_application/data/user_data.dart';
import 'package:chat_application/model/ChatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreApiImpl extends FirestoreApi {
  @override
  dynamic isSignedIn() {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user;
      } else {
        return false;
      }
    } on Exception catch (e) {
      throw NetworkFailedException(e.toString());
    }
  }

  @override
  Future signIn({required String email, required String password}) async {
    try {
      var response = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (response.user != null) {
        return response.user;
      } else {
        throw SignInFailedException("SignInFailedException : User is null");
      }
    } on Exception catch (e) {
      throw SignInFailedException("SignInFailedException : ${e.toString()}");
    }
  }

  @override
  Future signUp({required ChatUser user, required String password}) async {
    try {
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email!, password: password);
      if (response.user != null) {
        var res = await storeUserData(user: user);
        if (res is String) {
          return response.user;
        } else {
          throw SignUpFailedException(
              "SignUpFailedException : User data failed to store");
        }
      } else {
        throw SignUpFailedException("SignUpFailedException : User is null");
      }
    } on Exception catch (e) {
      throw SignInFailedException("SignUpFailedException : ${e.toString()}");
    }
  }

  @override
  Future storeUserData({required ChatUser user}) async {
    try {
      var ref =
          await FirebaseFirestore.instance.collection(users).add(user.toJson());
      return ref.id;
    } on Exception catch (e) {
      throw DataSavedException('DataSavedException : ${e.toString()}');
    }
  }

  @override
  Future getUserData() async {
    try {
      String email = FirebaseAuth.instance.currentUser?.email ?? '';
      var data = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (data.docs.isNotEmpty) {
        UserData.user = ChatUser.fromJson(data.docs[0].data());
        UserData.user.ref = data.docs[0].id;
        return UserData.user;
      } else {
        throw NoDataException('NoDataFoundException : No data');
      }
    } on Exception catch (e) {
      throw NoDataException('NoDataFoundException : ${e.toString()}');
    }
  }

  @override
  Future getUserDataByRef({required String ref}) async {
    try {
      var data =
          await FirebaseFirestore.instance.collection('users').doc(ref).get();
      ChatUser user = ChatUser.fromJson(data.data() ?? {});
      user.ref = data.id;
      return user;
    } on Exception catch (e) {
      throw NoDataException('NoDataFoundException : ${e.toString()}');
    }
  }
}
