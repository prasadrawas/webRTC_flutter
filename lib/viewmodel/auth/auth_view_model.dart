import 'package:chat_application/di/app_initializer.dart';
import 'package:chat_application/model/ChatUser.dart';
import 'package:chat_application/repository/app_repository.dart';
import 'package:chat_application/routing/navigator_service.dart';
import 'package:chat_application/routing/routes.dart';
import 'package:chat_application/utils/utilities.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  final _repository = AppInitializer.getIt<AppRepository>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  final navigator = AppInitializer.getIt<NavigationService>();

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void signIn(
      {required AuthViewModel viewModel, required BuildContext context}) {
    if (viewModel.formKey!.currentState!.validate()) {
      setLoading(true);
      String email = viewModel.emailController.text.trim();
      String password = viewModel.passwordController.text.trim();
      _repository.signIn(email: email, password: password).then((value) {
        setLoading(false);
        Navigator.pushNamed(context, Routes.homeRoute);
      }).onError((error, stackTrace) {
        setLoading(false);
        showToast(message: error.toString());
      });
    }
  }

  void signUp(
      {required AuthViewModel viewModel, required BuildContext context}) async {
    if (_validateForm(viewModel)) {
      setLoading(true);
      String name = viewModel.nameController.text.trim();
      String email = viewModel.emailController.text.trim();
      String password = viewModel.passwordController.text.trim();
      String token = await FirebaseMessaging.instance.getToken() ?? '';
      ChatUser user = ChatUser(name: name, email: email, token: token);
      _repository.signUp(user: user, password: password).then((value) {
        setLoading(false);
        Navigator.pushNamed(context, Routes.homeRoute);
      }).onError((error, stackTrace) {
        setLoading(false);
        showToast(message: error.toString());
      });
    }
  }

  bool _validateForm(viewModel) {
    if (viewModel.formKey!.currentState!.validate()) {
      return true;
    }
    return false;
  }
}
