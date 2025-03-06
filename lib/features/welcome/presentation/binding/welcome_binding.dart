import 'package:get/get.dart';

import '../../data/repo/welcome_repo_impl.dart';
import '../controller/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(
        repo: WelcomeRepositoryImpl(),
      ),
    );
  }
}
