import 'dart:convert';
import 'package:decent_chatbot/core/components/dialog_alert_widget.dart';
import 'package:decent_chatbot/core/components/loading_widget.dart';
import 'package:decent_chatbot/core/components/snackbar_widget.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/core/data/local_cache/local_cache_helper.dart';
import 'package:decent_chatbot/core/data/models/user_model.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:decent_chatbot/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRepo {
  static final AppRepo _singleton = AppRepo._internal();
  factory AppRepo() => _singleton;
  AppRepo._internal();

  // Private Resources
  bool _isGlobalLoadingOn = false;

  // Internal Resources
  final localCache = LocalCacheHelper();

  bool networkConnectivity = true;
  RxList<int> networkConnectivityStream = RxList<int>([]);

  final CustomSnackbar customSnackbar = CustomSnackbar(
    label: '',
    text: '',
  );

  // External Resources
  String? jwtToken;
  User? user;

  Future<void> getAllChats() async {
    // Placeholder for chat retrieval logic
  }

  /// Show a global loading dialog
  void showLoading() {
    if (_isGlobalLoadingOn) return;

    _isGlobalLoadingOn = true;
    if (Get.context == null) return;

    Get.dialog(PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => false,
      child: const CustomLoadingIndicator(),
    ));
  }

  /// Hide the global loading dialog
  void hideLoading() {
    if (!_isGlobalLoadingOn) return;
    if (Get.context == null) return;

    _isGlobalLoadingOn = false;
    Get.back();
  }

  /// Show a custom alert dialog
  void showCustomAlertDialog({
    required String title,
    required String content,
    required String buttonText,
    VoidCallback? onPressed,
    required Color buttonColor,
    required TextStyle buttonTextStyle,
    String? outlinedButtonText,
    VoidCallback? outlinedButtonOnPressed,
    Color outlinedButtonColor = Colors.blue,
    Color outlinedButtonBorderColor = Colors.blue,
    TextStyle outlinedButtonTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
  }) {
    if (Get.context == null) return;

    Get.dialog(
      CustomAlertDialogWidget(
        title: title,
        content: content,
        buttonText: buttonText,
        buttonColor: buttonColor,
        buttonTextStyle: buttonTextStyle,
        onPressed: onPressed,
        outlinedButtonText: outlinedButtonText,
        outlinedButtonOnPressed: outlinedButtonOnPressed,
        outlinedButtonColor: outlinedButtonColor,
        outlinedButtonBorderColor: outlinedButtonBorderColor,
        outlinedButtonTextStyle: outlinedButtonTextStyle,
      ),
    );
  }

  /// Show a snackbar
  void showSnackbar({
    required String label,
    required String text,
    IconData icon = Icons.info,
    Color? backgroundColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    CustomSnackbar(
      label: label,
      text: text,
      icon: icon,
      backgroundColor: backgroundColor ?? AppConfig().colors.secondaryColor,
      textColor: textColor,
      duration: duration,
      position: position,
      labelStyle: TextStyle(
        fontSize: 16,
        color: AppConfig().colors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppConfig().colors.primaryColor,
      ),
    ).show();
  }

  /// Handle user login and save data to cache
  Future<bool> loginUser(Map<String, dynamic> response) async {
    // Parse user object from response
    user = User.fromJson(response);
    jwtToken = user?.token;

    if (user?.userId == null) {
      throw Exception("User ID is missing in login response");
    }

    // Save user object to local cache
    await localCache.write(
      AppConfig().localCacheKeys.userObject,
      jsonEncode(user!.toJson()),
    );

    // Save logged-in status to local cache
    await localCache.write(
      AppConfig().localCacheKeys.userLoggedInStatus,
      UserStatus.loggedIn.toLocalCacheInt(),
    );

    return true;
  }

  /// Handle user logout and clear cache
  Future<void> logoutUser() async {
    showLoading();

    await localCache.clear();
    user = null;
    jwtToken = null;

    await Future.delayed(const Duration(seconds: 2));
    hideLoading();

    Get.offAllNamed(AppConfig().routes.splash);
  }
}
