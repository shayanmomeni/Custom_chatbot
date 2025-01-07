import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/features/splash/data/repo/splash_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({super.key});
  @override
  final controller = Get.put(SplashController(repo: SplashRepositoryImpl()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 140,
          ),
          Center(
            child: Text(
              'Decent Chatbot',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Icon(
            Icons.child_care_sharp,
            size: 100,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
