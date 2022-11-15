import 'package:chat_application/UI/components/loading_button.dart';
import 'package:chat_application/UI/components/text_edit_field.dart';
import 'package:chat_application/UI/shared/themes/app_theme.dart';
import 'package:chat_application/constants/color_constants.dart';
import 'package:chat_application/constants/string_constancts.dart';
import 'package:chat_application/di/app_initializer.dart';
import 'package:chat_application/routing/routes.dart';
import 'package:chat_application/utils/utilities.dart';
import 'package:chat_application/utils/validators.dart';
import 'package:chat_application/viewmodel/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _viewModel = AppInitializer.getIt<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: AppTheme.headingText,
                ),
                verticalSpacing(80),
                _buildForm(context),
                verticalSpacing(30),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.signInRoute);
                    },
                    child: const Text('Sign In'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildForm(context) {
    return Form(
      key: _viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextEditField(
            label: enterName,
            keyboardType: TextInputType.name,
            controller: _viewModel.nameController,
            validator: Validator.validateName,
          ),
          TextEditField(
            label: enterEmail,
            keyboardType: TextInputType.emailAddress,
            controller: _viewModel.emailController,
            validator: Validator.validateEmail,
          ),
          TextEditField(
            label: enterPass,
            keyboardType: TextInputType.visiblePassword,
            controller: _viewModel.passwordController,
            validator: Validator.validatePassword,
          ),
          verticalSpacing(50),
          Consumer<AuthViewModel>(
            builder: (context, controller, __) {
              return LoadingButton(
                onPressed: () {
                  controller.signUp(viewModel: _viewModel, context: context);
                },
                isLoading: controller.isLoading,
                buttonText: signUp,
                color: ColorConstants.blue10,
              );
            },
          ),
          verticalSpacing(50),
        ],
      ),
    );
  }
}
