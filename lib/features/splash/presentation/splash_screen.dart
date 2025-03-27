import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/features/splash/data/repo/splash_repo_impl.dart';
import 'package:decent_chatbot/features/user_check/data/repo/user_check_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({super.key});
  @override
  final controller = Get.put(SplashController(
      repo: SplashRepositoryImpl(), userCheckRepo: UserCheckRepositoryImpl()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backGroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 140),
          Center(
            child: Text(
              'Reflecto',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: AppColors().secondaryColor,
              ),
            ),
          ),
          Image.asset(
            'assets/png/logo.png',
            height: Get.height * 0.3,
          ),
        ],
      ),
    );
  }
}
