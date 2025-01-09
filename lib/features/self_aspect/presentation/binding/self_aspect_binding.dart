import 'package:get/get.dart';

import '../../data/repo/self_aspect_repo_impl.dart';
import '../controller/self_aspect_controller.dart';

class SelfAspectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelfAspectController>(
      () => SelfAspectController(
        repo: SelfAspectRepositoryImpl(),
      ),
    );
  }
}
