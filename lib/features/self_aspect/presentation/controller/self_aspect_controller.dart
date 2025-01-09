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

  void toggleSelection(String aspect) {
    // Create a new list to trigger reactivity
    final updatedList = [...selectedAspects];

    if (selectedAspects.contains(aspect)) {
      updatedList.remove(aspect);
    } else {
      if (selectedAspects.length < 10) {
        updatedList.add(aspect);
      } else {
        Get.snackbar(
          "Limit Reached",
          "You can only select up to 10 aspects.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppConfig().colors.snackbarColor,
        );
        return;
      }
    }
    // Assign the new list to trigger the update
    selectedAspects.value = updatedList;
  }
}
