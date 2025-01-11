import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/components/textfields_widget.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Obx(() {
        return Column(
          children: [
            CustomTextField(
              leftIcon: Icons.person,
              labelText: "Username",
              controller: controller.usernameController,
            ),
            Gap(AppConfig().dimens.medium),
            CustomTextField(
              leftIcon: Icons.lock,
              labelText: "Password",
              isPassword: true,
              secondIconOff: Icons.remove_red_eye,
              secondIconOn: Icons.remove_red_eye_outlined,
              controller: controller.passwordController,
            ),
            const Spacer(),
            CustomIconButton(
              title: controller.isLoading.value ? "Loading..." : "Login",
              onTap: controller.isLoading.value
                  ? null
                  : () => controller.login(), // Trigger login logic
              color: controller.isLoading.value
                  ? Colors.grey // Disabled button style
                  : AppConfig().colors.primaryColor,
            ),
            SizedBox(
              height: AppConfig().dimens.medium,
            ),
          ],
        ).paddingAll(AppConfig().dimens.medium);
      }),
    );
  }
}
