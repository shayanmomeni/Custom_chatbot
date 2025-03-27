import 'dart:convert';
import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:get/get.dart';
import '../../domain/user_check_repo.dart';

class UserCheckController extends GetxController {
  late UserCheckRepository repo;
  bool _hasNavigated = false; // Ensures navigation happens only once

  UserCheckController({required this.repo});

  @override
  void onInit() {
    super.onInit();
    checkUserStatus();
  }

  /// Checks if the user's imagesUploaded flag is true.
  /// If so, navigates to the chat screen.
  void checkUserStatus() {
    final user = AppRepo().user;
    if (user != null && user.imagesUploaded && !_hasNavigated) {
      _hasNavigated = true;
      print(
          "UserCheckController: imagesUploaded is TRUE, navigating to Chat...");
      Get.offNamed(AppConfig().routes.chat);
    } else {
      print(
          "UserCheckController: imagesUploaded is FALSE, remaining on UserCheck screen.");
    }
  }

  /// Refresh button action: fetch updated user data from backend.
  /// If imagesUploaded is true, route to chat; else, remain on the screen.
  Future<void> refreshUserStatus() async {
    try {
      final userId = AppRepo().user?.userId;
      if (userId == null) return;

      final updatedUser = await repo.fetchUserStatus(userId);
      if (updatedUser != null) {
        AppRepo().user = updatedUser;
        // Update local cache with the updated user data.
        AppRepo().localCache.write(
              AppConfig().localCacheKeys.userObject,
              jsonEncode(updatedUser.toJson()),
            );
        print(
            "Refresh: Updated user imagesUploaded: ${updatedUser.imagesUploaded}");
        if (updatedUser.imagesUploaded && !_hasNavigated) {
          _hasNavigated = true;
          print("Refresh: imagesUploaded is TRUE, navigating to Chat...");
          Get.offNamed(AppConfig().routes.chat);
        } else {
          print("Refresh: imagesUploaded is still FALSE.");
        }
      } else {
        print("Refresh: No updated user found.");
      }
    } catch (e) {
      print("Error refreshing user status: $e");
    }
  }
}
