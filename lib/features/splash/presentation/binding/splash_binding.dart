import 'package:get/get.dart';

import '../../data/repo/splash_repo_impl.dart';
import '../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        repo: SplashRepositoryImpl(),
      ),
    );
  }
}
