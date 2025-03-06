import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:get/get.dart';

import '../../domain/welcome_repo.dart';

class WelcomeController extends GetxController {
  late WelcomeRepository repo;

  WelcomeController({
    required this.repo,
  });

  Future<void> startAssessment() async {
    // Set the welcomeCompleted flag to true in local cache
    await AppRepo().localCache.write(
          AppConfig().localCacheKeys.welcomeCompleted,
          true,
        );
    // Navigate to the Assessment screen
    Get.offNamed(AppConfig().routes.assessment);
  }
}
