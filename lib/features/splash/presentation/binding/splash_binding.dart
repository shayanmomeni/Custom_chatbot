import 'package:decent_chatbot/features/splash/domain/splash_repo.dart';
import 'package:decent_chatbot/features/user_check/domain/user_check_repo.dart';
import 'package:get/get.dart';
import 'package:decent_chatbot/features/splash/presentation/controller/splash_controller.dart';
import 'package:decent_chatbot/features/splash/data/repo/splash_repo_impl.dart';
import 'package:decent_chatbot/features/user_check/data/repo/user_check_repo_impl.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashRepository>(() => SplashRepositoryImpl());
    Get.lazyPut<UserCheckRepository>(() => UserCheckRepositoryImpl());
    Get.lazyPut<SplashController>(
      () => SplashController(repo: Get.find(), userCheckRepo: Get.find()),
    );
  }
}
