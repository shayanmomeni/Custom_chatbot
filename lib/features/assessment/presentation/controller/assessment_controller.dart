import 'package:decent_chatbot/core/constants/config.dart';
import 'package:get/get.dart';

import '../../domain/assessment_repo.dart';

class AssessmentController extends GetxController {
  late AssessmentRepository repo;

  AssessmentController({
    required this.repo,
  });

  routeToChatScreen() {
    Get.offNamed(AppConfig().routes.chat);
  }
}
