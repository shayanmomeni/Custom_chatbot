import 'dart:convert';
import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/core/data/models/assessment_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/assessment_repo.dart';

class AssessmentController extends GetxController {
  late final AssessmentRepository repo;

  // List of 12 predefined questions
  final List<String> questions = const [
    "1) Describe your physical traits and background.",
    "2) How would you describe your inner self?",
    "3) What are you good at?",
    "4) What activities do you enjoy?",
    "5) What values or beliefs guide you?",
    "6) What is your current life situation?",
    "7) Who do you want to be?",
    "8) What would you like to improve?",
    "9) How do others see you?",
    "10) Name your key roles in your personal life.",
    "11) What roles do you play in society?",
    "12) List any other important parts of your identity.",
  ];

  // List of 12 predefined examples corresponding to each question
  final List<String> examples = const [
    "Example: e.g., tall, athletic, from a small town…",
    "Example: e.g., optimistic, thoughtful, sensitive...",
    "Example: e.g., problem-solver, creative writer, instrument player....",
    "Example: e.g., painter, jogger, reader....",
    "Example: honest, compassionate, feminist, environmentalism...",
    "Example: e.g., student, working professional, city dweller, divorcee....",
    "Example: e.g., aspiring doctor, entrepreneur, artist…",
    "Example: e.g., procrastination, impatience, self-doubt...",
    "Example: e.g., outgoing, reserved, humorous...",
    "Example: e.g., mom, best friend, daughter...",
    "Example: e.g., student, sibling, leader...",
    "Example: e.g., dreamer, achiever, creator…",
  ];

  // List of 12 non-reactive lists wrapped inside an RxList.
  // This way, whenever an inner list is modified, we call refresh() on the outer observable.
  final answers = List.generate(12, (_) => <String>[]).obs;

  // Text controllers for each question
  final textControllers = List.generate(12, (_) => TextEditingController());

  AssessmentController({required this.repo});

  // Add an answer to a specific question
  void addAnswer(int questionIndex, String answer) {
    if (answers[questionIndex].length < 10) {
      if (!answers[questionIndex].contains(answer)) {
        answers[questionIndex].add(answer);
        textControllers[questionIndex].clear();
        answers.refresh(); // Refresh the observable list so UI updates
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
    answers.refresh(); // Refresh to update the UI after deletion
  }

  // The submit button is enabled only if all 12 questions have at least one answer
  bool get isSubmitEnabled {
    return answers.every((questionAnswers) => questionAnswers.isNotEmpty);
  }

  // Submit the assessment answers to the backend
  Future<void> submitAssessment() async {
    // Ensure every question has at least one answer
    if (answers.any((questionAnswers) => questionAnswers.isEmpty)) {
      Get.snackbar(
        'Error',
        'Please provide at least one answer for all 12 questions.',
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
        answers: answers
            .map((questionAnswers) => List<String>.from(questionAnswers))
            .toList(),
      );

      // Save assessment answers via the repository
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
