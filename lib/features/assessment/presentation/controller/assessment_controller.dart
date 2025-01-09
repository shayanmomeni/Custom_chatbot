import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/assessment_repo.dart';

class AssessmentController extends GetxController {
  late AssessmentRepository repo;

  final selectedTags = <String>[].obs;
  final TextEditingController tagTextController = TextEditingController();

  AssessmentController({
    required this.repo,
  });

  void removeTag(String tag) {
    selectedTags.remove(tag);
  }

  void addTag(String tag) {
    if (selectedTags.length < 10) {
      if (!selectedTags.contains(tag)) {
        selectedTags.add(tag);
        tagTextController.clear();
      }
    } else {
      Get.snackbar('Limit reached', 'You can only add up to 10 answers.',
          backgroundColor: AppConfig().colors.snackbarColor);
    }
  }

  routeToSelfAspectScreen() {
    Get.toNamed(AppConfig().routes.selfAspect);
  }
}
