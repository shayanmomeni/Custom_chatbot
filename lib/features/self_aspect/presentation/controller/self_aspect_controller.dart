import 'dart:convert';

import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:get/get.dart';
import '../../domain/self_aspect_repo.dart';

class SelfAspectController extends GetxController {
  late final SelfAspectRepository repo;

  SelfAspectController({
    required this.repo,
  });

  // List of all available aspects (Initially empty, populated later)
  final aspects = <String>[].obs;

  // Reactive list to track selected aspects
  final selectedAspects = <String>[].obs;

  bool get isSubmitEnabled => selectedAspects.length == 10;

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      final userId = AppRepo().user?.userId;
      if (userId == null) throw Exception("User ID not found");

      final fetchedAspects = await repo.fetchUserAssessment(userId);
      aspects.assignAll(fetchedAspects);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void toggleSelection(String aspect) {
    if (selectedAspects.contains(aspect)) {
      selectedAspects.remove(aspect);
    } else {
      if (selectedAspects.length < 10) {
        selectedAspects.add(aspect);
      } else {
        Get.snackbar(
          "Limit Reached",
          "You can only select up to 10 aspects.",
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<void> handleSubmit() async {
    if (!isSubmitEnabled) {
      Get.snackbar(
        "Incomplete Selection",
        "Please select exactly 10 aspects before submitting.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final userId = AppRepo().user?.userId;
      if (userId == null) throw Exception("User ID not found");

      final response = await repo.saveSelfAspects(userId, selectedAspects);

      // Update local cache to mark self-aspect as completed
      final user = AppRepo().user;
      if (user != null) {
        user.selfAspectCompleted = true;
        AppRepo().localCache.write(
          AppConfig().localCacheKeys.userObject,
          jsonEncode(user.toJson()),
        );
      }

      Get.snackbar(
        "Success",
        response['message'] ?? "Self-aspects saved successfully.",
      );

      Get.offNamed(AppConfig().routes.chat);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}