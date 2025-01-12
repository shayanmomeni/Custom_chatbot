import 'dart:convert';

import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/self_aspect_repo.dart';

class SelfAspectController extends GetxController {
  late final SelfAspectRepository repo;

  SelfAspectController({required this.repo});

  // List of all available aspects
  final aspects = <String>[].obs;

  // Map to track selection state of each aspect
  final selectionState = <String, bool>{}.obs;

  // Computed property for selected aspects
  List<String> get selectedAspects =>
      selectionState.entries.where((e) => e.value).map((e) => e.key).toList();

  bool get isSubmitEnabled => selectedAspects.length == 10;

  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      final userId = AppRepo().user?.userId;
      if (userId == null) throw Exception("User ID not found");

      final fetchedAspects = await repo.fetchUserAssessment(userId);
      final separatedAspects = fetchedAspects
          .expand((aspect) => aspect.split(','))
          .map((aspect) => aspect.trim())
          .where((aspect) => aspect.isNotEmpty)
          .toList();

      aspects.value = separatedAspects;

      // Initialize selection state map
      selectionState.assignAll({
        for (var aspect in separatedAspects) aspect: false,
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void toggleSelection(String aspect) {
    if (selectionState[aspect] ?? false) {
      selectionState[aspect] = false;
    } else if (selectedAspects.length < 10) {
      selectionState[aspect] = true;
    } else {
      Get.snackbar(
        "Limit Reached",
        "You can only select up to 10 aspects.",
        snackPosition: SnackPosition.TOP,
      );
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

      // Debug log before sending request
      debugPrint(
          "Submitting payload: { userId: $userId, selectedAspects: $selectedAspects }");

      final response = await repo.saveSelfAspects(userId, selectedAspects);

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
