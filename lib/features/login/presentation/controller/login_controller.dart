import 'package:decent_chatbot/core/constants/config.dart';
import 'package:get/get.dart';

import '../../domain/login_repo.dart';

class LoginController extends GetxController {
  late LoginRepository repo;

  LoginController({
    required this.repo,
  });

  routeToAssessment() {
    Get.offNamed(AppConfig().routes.assessment);
  }
}
