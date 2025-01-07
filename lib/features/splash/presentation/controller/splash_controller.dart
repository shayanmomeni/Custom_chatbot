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

  SplashController({
    required this.repo,
  });

  Future<void> checkUserStatusFromLocalCache() async {
    print('Checking user status from local cache...');
    final rawUserStatusFromLocalCache = AppRepo()
        .localCache
        .read<int>(AppConfig().localCacheKeys.userLoggedInStatus);

    await Future.delayed(const Duration(seconds: 2));

    switch (rawUserStatusFromLocalCache?.toUserStatus()) {
      case UserStatus.loggedIn:
        final userObjectStr = await repo.fetchUserFromLocalCache();

        if (userObjectStr == null) {
          AppRepo().logoutUser();
          Get.offNamed(AppConfig().routes.login);
          print('User is logged out');
          break;
        }
        print('------> User: ${userObjectStr}');
        final userObject = User.fromLocalCacheJson(jsonDecode(userObjectStr!));

        AppRepo().user = userObject;
        AppRepo().jwtToken = userObject.token;

        Get.offNamed(AppConfig().routes.login);
        print('User is logged in');
        print('------> User: ${userObject}');
        break;
      case UserStatus.loggedOut:
        Get.offNamed(AppConfig().routes.login);
        print('User is logged out');
        break;
      case null:
        Get.offNamed(AppConfig().routes.login);
        print('User status is null');
        break;
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
