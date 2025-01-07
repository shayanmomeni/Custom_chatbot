import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/components/textfields_widget.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        spacing: AppConfig().dimens.medium,
        children: [
          CustomTextField(
            leftIcon: Icons.email,
            labelText: "Email",
          ),
          CustomTextField(
            leftIcon: Icons.lock,
            labelText: "Password",
            isPassword: true,
            secondIconOff: Icons.remove_red_eye,
            secondIconOn: Icons.remove_red_eye_outlined,
          ),
          Spacer(),
          CustomIconButton(
            title: "Login",
            onTap: () => controller.routeToAssessment(),
            color: AppConfig().colors.primaryColor,
          ),
          SizedBox(
            height: AppConfig().dimens.medium,
          ),
        ],
      ).paddingAll(AppConfig().dimens.medium),
    );
  }
}
