import 'package:decent_chatbot/core/constants/config.dart';
import 'package:get/get.dart';
import '../../domain/self_aspect_repo.dart';

class SelfAspectController extends GetxController {
  late SelfAspectRepository repo;

  SelfAspectController({
    required this.repo,
  }) {
    print("SelfAspectController has been initialized.");
  }

  // List of all available aspects
  final aspects = <String>[
    "Hardworking",
    "Creative",
    "Empathetic",
    "Innovative",
    "Team Player",
    "Reliable",
    "Proactive",
    "Curious",
    "Analytical",
    "Detail-Oriented",
    "Flexible",
    "Confident",
    "Honest",
    "Self-Motivated",
  ].obs;

  // Reactive list to track selected aspects
  final selectedAspects = <String>[].obs;

  bool get isSubmitEnabled => selectedAspects.length == 10;

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
          backgroundColor: AppConfig().colors.snackbarColor,
        );
      }
    }
  }

  void handleSubmit() {
    if (!isSubmitEnabled) {
      Get.snackbar(
        "Incomplete Selection",
        "Please select exactly 10 aspects before submitting.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppConfig().colors.snackbarColor,
      );
      return;
    }
    routeToChat();
  }

  void routeToChat() {
    Get.toNamed(AppConfig().routes.chat);
  }
}
