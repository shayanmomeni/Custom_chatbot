import 'dart:convert';

import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/core/data/models/user_model.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:decent_chatbot/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/splash_repo.dart';

class SplashController extends GetxController {
  late SplashRepository repo;

  SplashController({required this.repo});

  Future<void> checkUserStatusFromLocalCache() async {
    print('Checking user status from local cache...');

    final rawUserStatusFromLocalCache = AppRepo()
        .localCache
        .read<int>(AppConfig().localCacheKeys.userLoggedInStatus);

    await Future.delayed(const Duration(seconds: 2));

    try {
      switch (rawUserStatusFromLocalCache?.toUserStatus()) {
        case UserStatus.loggedIn:
          final userObjectStr =
              AppRepo().localCache.read(AppConfig().localCacheKeys.userObject);

          if (userObjectStr == null) {
            print("No user object found in local cache. Logging out...");
            AppRepo().logoutUser();
            Get.offNamed(AppConfig().routes.login);
            break;
          }

          final userObject = User.fromLocalCacheJson(jsonDecode(userObjectStr));
          AppRepo().user = userObject;
          AppRepo().jwtToken = userObject.token;

          if (userObject.userId == null) {
            print("Invalid user data: User ID is null. Logging out...");
            AppRepo().logoutUser();
            Get.offNamed(AppConfig().routes.login);
            break;
          }

          print(
              "User loaded: Username = ${userObject.username}, ID = ${userObject.userId}");

          final welcomeCompleted = AppRepo()
                  .localCache
                  .read<bool>(AppConfig().localCacheKeys.welcomeCompleted) ??
              false;

          if (userObject.assessmentCompleted == false) {
            if (!welcomeCompleted) {
              print("Navigating to Welcome Screen...");
              Get.offNamed(AppConfig().routes.welcome);
            } else {
              print("Navigating to Assessment Screen...");
              Get.offNamed(AppConfig().routes.assessment);
            }
          } else if (userObject.selfAspectCompleted == false) {
            print("Navigating to Self-Aspect Screen...");
            Get.offNamed(AppConfig().routes.selfAspect);
          } else {
            print("Navigating to Chat Screen...");
            Get.offNamed(AppConfig().routes.chat);
          }
          break;

        case UserStatus.loggedOut:
        case null:
          print("User is logged out or status is null. Navigating to Login...");
          Get.offNamed(AppConfig().routes.login);
          break;
      }
    } catch (e) {
      print("Error in SplashController: $e");
      Get.offNamed(AppConfig().routes.login);
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserStatusFromLocalCache();
    });
  }
}
