import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'controller/welcome_controller.dart';
import 'package:decent_chatbot/core/components/buttons_widgets.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors().backGroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors().backGroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(60),
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 30,
                  color: AppColors().secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              Text(
                'to your self-assessment test!',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors().txtHeaderColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(60),
              Text(
                'Take a moment to reflect on each question. Tap “+ Add Answer” to enter your response. Feel free to add as many answers as you like—there are no right or wrong answers.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors().txtHeaderColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(120),
              CustomIconButton(
                title: 'Start Assessment Test',
                onTap: controller.startAssessment,
                color: AppColors().primaryColor,
              ),
            ],
          ).paddingAll(AppConfig().dimens.medium),
        ),
      ),
    );
  }
}
