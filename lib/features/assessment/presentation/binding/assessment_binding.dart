import 'package:decent_chatbot/core/data/services/assessment_service.dart';
import 'package:get/get.dart';

import '../../data/repo/assessment_repo_impl.dart';
import '../controller/assessment_controller.dart';

class AssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssessmentController>(
      () => AssessmentController(
        repo: AssessmentRepositoryImpl(
          AssessmentService(),
        ),
      ),
    );
  }
}
