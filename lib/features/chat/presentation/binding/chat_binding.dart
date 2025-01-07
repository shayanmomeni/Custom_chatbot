import 'package:get/get.dart';

import '../../data/repo/chat_repo_impl.dart';
import '../controller/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(
        repo: ChatRepositoryImpl(),
      ),
    );
  }
}
