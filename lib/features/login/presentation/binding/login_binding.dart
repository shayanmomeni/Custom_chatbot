import 'package:decent_chatbot/core/data/services/auth_service.dart';
import 'package:get/get.dart';
import '../../data/repo/login_repo_impl.dart';
import '../controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        repository: LoginRepositoryImpl(
          LoginService(),
        ),
      ),
    );
  }
}
