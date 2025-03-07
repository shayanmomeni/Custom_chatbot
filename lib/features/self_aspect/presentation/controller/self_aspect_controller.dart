import 'dart:convert';
import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/self_aspect_repo.dart';

class SelfAspectController extends GetxController {
  late final SelfAspectRepository repo;

  SelfAspectController({required this.repo});

  // List of all available aspects (may include duplicate names)
  final aspects = <String>[].obs;

  // List of booleans tracking selection state for each aspect
  final selectionState = <bool>[].obs;

  // Computed property for selected aspects based on index
  List<String> get selectedAspects {
    List<String> result = [];
    for (int i = 0; i < aspects.length; i++) {
      if (i < selectionState.length && selectionState[i]) {
        result.add(aspects[i]);
      }
    }
    return result;
  }

  // Enable submission only when exactly 6 aspects are selected.
  bool get isSubmitEnabled => selectedAspects.length == 6;

  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      final userId = AppRepo().user?.userId;
      if (userId == null) throw Exception("User ID not found");

      final fetchedAspects = await repo.fetchUserAssessment(userId);
      // The fetched aspects may be stored as comma-separated strings.
      // Split them, trim, and remove empties.
      final separatedAspects = fetchedAspects
          .expand((aspect) => aspect.split(','))
          .map((aspect) => aspect.trim())
          .where((aspect) => aspect.isNotEmpty)
          .toList();

      aspects.value = separatedAspects;
      // Initialize the selection state list with false for each aspect.
      selectionState.value = List<bool>.filled(separatedAspects.length, false);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Toggle selection for an aspect at the given index.
  /// This allows each duplicate item to be toggled individually.
  void toggleSelectionAtIndex(int index) {
    if (index < 0 || index >= selectionState.length) return;
    // If currently selected, deselect it.
    if (selectionState[index]) {
      selectionState[index] = false;
    } else {
      // Only allow selection if we haven't reached 6 selections yet.
      if (selectedAspects.length < 6) {
        selectionState[index] = true;
      } else {
        Get.snackbar(
          "Limit Reached",
          "You can only select exactly 6 aspects.",
          snackPosition: SnackPosition.TOP,
        );
      }
    }
    selectionState.refresh();
  }

  /// If your UI passes the index of the aspect, call this method.
  void toggleSelection(String aspect, int index) {
    // We use the provided index to disambiguate duplicates.
    toggleSelectionAtIndex(index);
  }

  Future<void> handleSubmit() async {
    if (!isSubmitEnabled) {
      Get.snackbar(
        "Incomplete Selection",
        "Please select exactly 6 aspects before submitting.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final userId = AppRepo().user?.userId;
      if (userId == null) throw Exception("User ID not found");

      // Debug log before sending request.
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
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors().secondaryColor,
      );
      Get.offNamed(AppConfig().routes.chat);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors().secondaryColor,
      );
    }
  }
}
