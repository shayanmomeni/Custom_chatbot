import 'package:get/get.dart';
import '../../data/repo/user_check_repo_impl.dart';
import '../../domain/user_check_repo.dart';
import '../controller/user_check_controller.dart';

class UserCheckBinding extends Bindings {
  @override
  void dependencies() {
    // Bind the repository first.
    Get.lazyPut<UserCheckRepository>(() => UserCheckRepositoryImpl());
    // Then bind the controller with the repository from Get.find.
    Get.lazyPut<UserCheckController>(
      () => UserCheckController(
        repo: Get.find<UserCheckRepository>(),
      ),
    );
  }
}
