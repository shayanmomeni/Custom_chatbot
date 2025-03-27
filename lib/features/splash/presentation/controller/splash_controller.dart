import 'dart:convert';
import 'package:decent_chatbot/core/utils/extentions.dart';
import 'package:decent_chatbot/features/splash/domain/splash_repo.dart';
import 'package:get/get.dart';
import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/core/data/models/user_model.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:decent_chatbot/features/user_check/domain/user_check_repo.dart'; // Assuming correct path
import 'package:flutter/material.dart';

class SplashController extends GetxController {
  late SplashRepository repo; // Assuming this is defined somewhere
  late UserCheckRepository userCheckRepo;

  SplashController({required this.repo, required this.userCheckRepo});

  Future<void> checkUserStatusFromLocalCache() async {
    print('Checking user status from local cache...');
    final rawUserStatusFromLocalCache = AppRepo()
        .localCache
        .read<int>(AppConfig().localCacheKeys.userLoggedInStatus);

    await Future.delayed(const Duration(seconds: 2));

    try {
      UserStatus status = rawUserStatusFromLocalCache.toUserStatus();
      switch (status) {
        case UserStatus.loggedIn:
          final userObjectStr =
              AppRepo().localCache.read(AppConfig().localCacheKeys.userObject);
          if (userObjectStr == null) {
            print("No user object found in local cache. Logging out...");
            AppRepo().logoutUser();
            Get.offNamed(AppConfig().routes.login);
            return;
          }

          User cachedUser = User.fromLocalCacheJson(jsonDecode(userObjectStr));
          AppRepo().user = cachedUser;
          AppRepo().jwtToken = cachedUser.token;

          if (cachedUser.userId == null) {
            print("Invalid user data: User ID is null. Logging out...");
            AppRepo().logoutUser();
            Get.offNamed(AppConfig().routes.login);
            return;
          }

          print(
              "Cached user loaded: Username = ${cachedUser.username}, ID = ${cachedUser.userId}");

          // Fetch updated user status from backend to ensure all data is current
          final updatedUser =
              await userCheckRepo.fetchUserStatus(cachedUser.userId!);
          if (updatedUser != null) {
            AppRepo().user = updatedUser;
            AppRepo().localCache.write(AppConfig().localCacheKeys.userObject,
                jsonEncode(updatedUser.toJson()));

            if (updatedUser.assessmentAspectCompleted &&
                updatedUser.imagesUploaded) {
              print("All criteria met, navigating to Chat...");
              Get.offNamed(AppConfig().routes.chat);
            } else {
              print("Navigating to UserCheck Screen...");
              Get.offNamed(AppConfig().routes.userCheck);
            }
          } else {
            // Fallback to cached data if the network call fails
            if (cachedUser.assessmentAspectCompleted &&
                cachedUser.imagesUploaded) {
              print("Using cached data, navigating to Chat...");
              Get.offNamed(AppConfig().routes.chat);
            } else {
              print("Using cached data, navigating to UserCheck Screen...");
              Get.offNamed(AppConfig().routes.userCheck);
            }
          }
          break;

        case UserStatus.loggedOut:
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
    // Ensure the user check repository is available
    userCheckRepo = Get.find<UserCheckRepository>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserStatusFromLocalCache();
    });
  }
}
