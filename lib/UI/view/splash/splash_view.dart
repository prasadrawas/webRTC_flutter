import 'package:chat_application/UI/shared/themes/app_theme.dart';
import 'package:chat_application/di/app_initializer.dart';
import 'package:chat_application/repository/app_repository.dart';
import 'package:chat_application/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/dimensions/dimensions.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _repository = AppInitializer.getIt<AppRepository>();

  @override
  void initState() {
    super.initState();
    _navigateToApp();
  }

  void _navigateToApp() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pushNamed(context, Routes.homeRoute);
      });
    } else {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pushNamed(context, Routes.signInRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding:
                const EdgeInsets.only(left: Dimens.px16, right: Dimens.px16),
            child: const Text(
              'Chat Application',
              style: AppTheme.headingText,
            ),
          ),
        ),
      ),
    );
  }
}
