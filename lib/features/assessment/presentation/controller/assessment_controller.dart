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

  // Add a tag to a specific question's selectedTagsList
  void addTag(int questionIndex, String tag) {
    if (selectedTagsList[questionIndex].length < 10) {
      if (!selectedTagsList[questionIndex].contains(tag)) {
        selectedTagsList[questionIndex].add(tag);
        tagTextControllers[questionIndex].clear();
      }
    } else {
      Get.snackbar(
        'Limit reached',
        'You can only add up to 10 answers per question.',
        backgroundColor: AppConfig().colors.snackbarColor,
      );
    }
  }

  // Remove a tag from a specific question's selectedTagsList
  void removeTag(int questionIndex, String tag) {
    selectedTagsList[questionIndex].remove(tag);
  }

  // Submit the assessment answers to the backend
  Future<void> submitAssessment(String userId) async {
    try {
      // Convert selectedTagsList to a flat list of answers
      final answers = selectedTagsList.expand((tags) => tags).toList();
      await repo.saveAssessment(userId, answers);
      Get.snackbar(
        'Success',
        'Assessment answers submitted successfully.',
        backgroundColor: AppConfig().colors.snackbarColor,
      );
      routeToSelfAspectScreen();
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to submit assessment answers.',
        backgroundColor: AppConfig().colors.snackbarColor,
      );
    }
  }

  // Navigate to the self-aspect screen after submitting answers
  void routeToSelfAspectScreen() {
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
