import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'controller/user_check_controller.dart';

class UserCheckScreen extends GetView<UserCheckController> {
  const UserCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You need to wait until we prepare the pictures for you. We will notify you when it is ready.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors().secondaryColor,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            Gap(16),
            CustomIconButton(
              title: 'Refresh',
              onTap: controller.refreshUserStatus,
              color: AppColors().secondaryColor,
              txtColor: AppColors().primaryColor,
              paddingHorizontal: 32,
              paddingVertical: 16,
            ),
          ],
        ).paddingAll(32),
      ),
    );
  }
}
