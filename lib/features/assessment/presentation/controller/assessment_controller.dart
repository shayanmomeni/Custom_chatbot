import 'dart:convert';
import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/core/data/models/assessment_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/assessment_repo.dart';

class AssessmentController extends GetxController {
  late final AssessmentRepository repo;

  // List of 10 reactive lists for each question's answers
  final answers = List.generate(10, (_) => <String>[].obs).obs;

  // Text controllers for each question
  final textControllers = List.generate(10, (_) => TextEditingController());

  AssessmentController({required this.repo});

  // Add an answer to a specific question
  void addAnswer(int questionIndex, String answer) {
    if (answers[questionIndex].length < 10) {
      if (!answers[questionIndex].contains(answer)) {
        answers[questionIndex].add(answer);
        textControllers[questionIndex].clear();
      }
    } else {
      Get.snackbar(
        'Limit reached',
        'You can only add up to 10 answers per question.',
        backgroundColor: AppConfig().colors.snackbarColor,
      );
    }
  }

  // Remove an answer from a specific question
  void removeAnswer(int questionIndex, String answer) {
    answers[questionIndex].remove(answer);
  }

  // Check if the submit button should be enabled
  bool get isSubmitEnabled {
    return answers.every((questionAnswers) => questionAnswers.isNotEmpty);
  }

  // Submit the assessment answers to the backend
  Future<void> submitAssessment() async {
    // Check if every question has at least one answer
    if (answers.any((questionAnswers) => questionAnswers.isEmpty)) {
      Get.snackbar(
        'Error',
        'Please provide at least one answer for all 10 questions.',
        backgroundColor: AppConfig().colors.snackbarColor,
      );
      return;
    }

    try {
      final userId = AppRepo().user?.userId;
      if (userId == null) throw Exception("User ID not found");

      // Prepare the assessment request object
      final request = AssessmentRequest(
        userId: userId,
        answers: answers.map((questionAnswers) => questionAnswers.toList()).toList(),
      );

      // Call the repository to save assessment
      await repo.saveAssessment(request);

      // Update local cache to mark assessment as completed
      final user = AppRepo().user;
      if (user != null) {
        user.assessmentCompleted = true;
        AppRepo().localCache.write(
          AppConfig().localCacheKeys.userObject,
          jsonEncode(user.toJson()),
        );
      }

      Get.snackbar(
        'Success',
        'Assessment answers submitted successfully.',
        backgroundColor: AppConfig().colors.snackbarColor,
      );

      routeToSelfAspectScreen();
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to submit assessment answers: ${error.toString()}',
        backgroundColor: AppConfig().colors.snackbarColor,
      );
    }
  }

  // Navigate to the self-aspect screen
  void routeToSelfAspectScreen() {
    Get.toNamed(AppConfig().routes.selfAspect);
  }

  @override
  void dispose() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}