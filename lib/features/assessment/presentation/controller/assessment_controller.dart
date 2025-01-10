import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/assessment_repo.dart';

class AssessmentController extends GetxController {
  late AssessmentRepository repo;

  final selectedTagsList = List.generate(10, (_) => <String>[].obs).obs;
  final tagTextControllers = List.generate(10, (_) => TextEditingController());

  AssessmentController({
    required this.repo,
  });

  void removeTag(int index, String tag) {
    selectedTagsList[index].remove(tag);
  }

  void addTag(int index, String tag) {
    if (selectedTagsList[index].length < 10) {
      if (!selectedTagsList[index].contains(tag)) {
        selectedTagsList[index].add(tag);
        tagTextControllers[index].clear();
      }
    } else {
      Get.snackbar('Limit reached', 'You can only add up to 10 answers.',
          backgroundColor: AppConfig().colors.snackbarColor);
    }
  }

  routeToSelfAspectScreen() {
    Get.toNamed(AppConfig().routes.selfAspect);
  }

  @override
  void dispose() {
    for (var controller in tagTextControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
